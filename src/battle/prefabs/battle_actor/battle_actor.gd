extends Node3D
class_name BattleActor


signal entered_battle()

var skin: ActorSkin = null
var character_state: CharacterState
var signal_bus: BattleSignalBus
var battle_context: BattleContext


func _ready() -> void:
	add_to_group(Groups.BATTLE_ACTOR)
	skin = character_state.get_skin_scene().instantiate()
	character_state.restart_animation.connect(_on_restart_animation)
	add_child(skin)
	skin.set_get_idle_animation(_get_idle_animation)
	signal_bus.request_animation.connect(_on_request_animation)
	signal_bus.on_hit.connect(_on_hit)
	signal_bus.on_heal.connect(_on_heal)
	signal_bus.on_reflect.connect(_on_reflect)
	signal_bus.on_death.connect(_on_death)
	signal_bus.on_apply_ailment.connect(_on_apply_ailment)
	await get_tree().create_timer(0.1).timeout ## TODO: Wait for skin and entry animation to play
	entered_battle.emit()


static func from_state(p_state: CharacterState) -> BattleActor:
	var actor = BattleActor.new()
	actor.character_state = p_state
	return actor

func get_character_id() -> int:
	return character_state.get_instance_id()

func _on_request_animation(character: CharacterState, animation_name: StringName, eventful: bool) -> void:
	if character != character_state:
		return
	if eventful:
		await skin.play_eventful_animation(animation_name)
		signal_bus.on_animation_event.emit(character)
	else:
		skin.play_animation(animation_name)
		await skin.animation_finished
		signal_bus.on_animation_event.emit(character)
	
func _on_death(user: CharacterState) -> void:
	if user != character_state:
		return
	skin.play_dead_animation()

## TODO: Check if user is needed in this function
func _on_hit(_user: CharacterState, target: CharacterState, hit: Hit) -> void:
	if target != character_state:
		return
	
	match hit.hit_type:
		Hit.HitType.MISS:
			skin.play_dodge_animation()
		Hit.HitType.BLOCK:
			pass
		_:
			skin.play_hit_animation()


func _on_heal(user: CharacterState, target: CharacterState, _amount: int) -> void:
	if target != character_state:
		return
	if user != target:
		## TODO: Thank user? Some kind of animation
		pass
	
	## TODO: Actually animate the skin here
	await GlobalTimers.wait(0.1)

func _on_reflect(user: CharacterState, target: CharacterState) -> void:
	if target != character_state:
		return

	assert(user != target, "Reflect event where user and target are the same")
	
	## TODO: Currently multiple shields get created, might not be needed
	var shield := ReflectShield.create_new()
	add_child(shield)
	var from_position := get_target_position(TargetPosition.Type.FEET)
	var to_position := battle_context.get_actor_from_character(user).get_target_position(TargetPosition.Type.CENTER_OF_MASS)
	shield.play(from_position, to_position)

func _on_apply_ailment(target: CharacterState, succeeded: bool) -> void:
	if target != character_state:
		return
	
	if succeeded:
		skin.play_dodge_animation()
	## TODO: Else

func get_target_position(target_position_type: TargetPosition.Type) -> Vector3:
	match target_position_type:
		TargetPosition.Type.CENTER_OF_MASS:
			return skin.center_of_mass.global_position
		TargetPosition.Type.ABOVE_HEAD:
			return skin.above_head.global_position
		_:
			return global_position

func _get_idle_animation() -> StringName:
	return character_state.get_idle_animation()

func _on_restart_animation() -> void:
	skin.restart_animation()
