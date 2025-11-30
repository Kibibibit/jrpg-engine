extends Node
class_name BattleCharacterStateManager

@export var signal_bus: BattleSignalBus
@export var battle_context: BattleContext

func _ready() -> void:
	assert(signal_bus != null, "BattleCharacterStateManager: signal_bus must be assigned.")
	assert(battle_context != null, "BattleCharacterStateManager: battle_context must be assigned.")

	signal_bus.request_character_pre_turn.connect(_on_request_character_pre_turn)
	signal_bus.request_character_post_turn.connect(_on_request_character_post_turn)
	signal_bus.request_apply_ailment_post_effect.connect(_apply_ailment_post_effect)

func _on_request_character_pre_turn(character: CharacterState) -> void:
	if character.get_is_defending():
		character.set_is_defending(false)

	signal_bus.on_character_pre_turn_complete.emit(character)

func _on_request_character_post_turn(character: CharacterState) -> void:

	var ailment_post_effects: Array[AilmentPostEffect] = []
	for ailment in character.ailments:
		var post_effect := ailment.get_post_effect()
		if post_effect != null:
			ailment_post_effects.append(post_effect)
	
	for post_effect in ailment_post_effects:
		signal_bus.request_apply_ailment_post_effect.emit(character, post_effect)
	


	character.reduce_ailments()

	signal_bus.on_character_post_turn_complete.emit(character)

func _apply_ailment_post_effect(character: CharacterState, post_effect: AilmentPostEffect) -> void:
	var resource: CostResource.Type = post_effect.resource_type
	var amount: int = 0
	if post_effect.flat_amount:
		amount = post_effect.amount
	else:
		var total: float = 0.0
		if resource == CostResource.HP:
			total = float(character.get_max_hp())
		else:
			total = float(character.get_max_mp())
		amount = floori((float(post_effect.amount) / 100.0) * total)

	if resource == CostResource.MP:
		## TODO: MP damage numbers 
		character.set_current_mp(character.get_current_mp() - amount)
		return
	
	if amount < 0:
		character.heal(absi(amount))
		signal_bus.on_heal.emit(character, character, absi(amount))
	else:
		character.damage(amount)
		var hit := Hit.new()
		hit.damage_amount = amount
		hit.hit_type = Hit.HitType.NORMAL
		signal_bus.on_hit.emit(character, character, hit)
		if not character.is_alive():
			signal_bus.on_death.emit(character)
