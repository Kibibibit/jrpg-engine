extends Node
class_name BattleTurnOrder

## TODO: Refactor this out into the battle context potentially? Or at the very least store
## it in the battle context?

@export var battle_context: BattleContext = null
@export var signal_bus: BattleSignalBus = null


var turn_order: Array[CharacterState] = []

func _ready() -> void:
	assert(battle_context != null, "BattleTurnOrder: battle_context is null")
	assert(signal_bus != null, "BattleTurnOrder: signal_bus is null")

	signal_bus.request_next_turn.connect(_on_request_next_turn)
	signal_bus.on_death.connect(_on_character_death)


func _on_request_next_turn() -> void:
	if turn_order.is_empty():
		_create_turn_order()

	var next_character: CharacterState = turn_order.pop_front()
	signal_bus.request_character_turn.emit(next_character)

func _create_turn_order() -> void:
	turn_order.clear()
	var characters: Array[CharacterState] = battle_context.get_characters(true).duplicate()

	assert(characters.size() > 0, "BattleTurnOrder: No alive characters to create turn order from")

	characters.sort_custom(func(a: CharacterState, b: CharacterState) -> bool:
		return a.get_initiative() > b.get_initiative()
	)
	turn_order = characters

func _on_character_death(user: CharacterState) -> void:
	if user in turn_order:
		turn_order.erase(user)
