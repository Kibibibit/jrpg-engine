extends Node
class_name BattleTurnManager


@export var battle_context: BattleContext = null
@export var signal_bus: BattleSignalBus = null


func _ready() -> void:
	assert(battle_context != null, "BattleTurnManager: battle_context is null")
	assert(signal_bus != null, "BattleTurnManager: signal_bus is null")
	
	signal_bus.request_next_turn.connect(_on_request_next_turn)
	signal_bus.on_death.connect(_on_character_death)
	signal_bus.on_skill_selected.connect(_execute_skill)
	signal_bus.request_pass.connect(_on_request_pass)

func _on_request_next_turn() -> void:
	if battle_context.turn_order.is_empty():
		_create_turn_order()
		

	var character: CharacterState = battle_context.turn_order.front()
	
	_on_character_turn_start(character)

	var character_team: Team.Type = battle_context.get_character_team(character)
	
	if character_team == Team.PLAYER and character.is_controllable():
		signal_bus.request_player_character_turn.emit(character)
	else:
		signal_bus.request_ai_character_turn.emit(character)
	
	## TODO: Await other things too maybe?
	await signal_bus.all_skill_instances_finished
	## TODO: Replace with a check for ui events to be done
	await GlobalTimers.wait(1.0)
	
	_on_character_turn_end(character)
	
	battle_context.turn_order.pop_front()
	signal_bus.turn_order_changed.emit()
	signal_bus.request_next_turn.emit()


func _execute_skill(character: CharacterState, skill: Skill, targets: Array[CharacterState]) -> void:
	var resource: Skill.CostResource = skill.cost_resource
	var amount: int = SkillUtils.calculate_cost(skill, character)
	if resource == Skill.CostResource.MP:
		character.set_current_mp(character.get_current_mp() - amount)
	else:
		character.set_current_hp(character.get_current_hp() - amount)
	
	signal_bus.request_execute_skill.emit(character, skill, targets)



func _create_turn_order() -> void:
	battle_context.turn_order.clear()
	var characters: Array[CharacterState] = battle_context.get_characters(true).duplicate()

	assert(characters.size() > 0, "BattleTurnManager: No alive characters to create turn order from")

	characters.sort_custom(func(a: CharacterState, b: CharacterState) -> bool:
		return a.get_initiative() > b.get_initiative()
	)
	battle_context.turn_order = characters
	signal_bus.turn_order_changed.emit()

func _on_character_death(user: CharacterState) -> void:
	if user in battle_context.turn_order:
		battle_context.turn_order.erase(user)
	signal_bus.turn_order_changed.emit()


func _on_character_turn_start(character: CharacterState) -> void:
	if character.get_is_defending():
		character.set_is_defending(false)

func _on_character_turn_end(_character: CharacterState) -> void:
	## TODO: Ailments that deal damage, etc
	pass

func _on_request_pass(character: CharacterState) -> void:
	battle_context.turn_order.push_back(character)
	signal_bus.turn_order_changed.emit()
