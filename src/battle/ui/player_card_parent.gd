extends HBoxContainer
class_name PlayerCardParent

@export var parent: BattleUI

var signal_bus: BattleSignalBus
var battle_context: BattleContext

func _ready() -> void:
	signal_bus = parent.signal_bus
	battle_context = parent.battle_context
	assert(signal_bus != null, "PlayerCardParent: signal_bus is undefined")
	assert(battle_context != null, "PlayerCardParent: battle_context is undefined")

	signal_bus.all_actors_entered_battle.connect(_on_all_actors_entered_battle)

func _on_all_actors_entered_battle() -> void:
	var characters: Array[CharacterState] = battle_context.get_team_characters(Team.PLAYER)
	for character in characters:
		add_child(PlayerCard.create_new(character))
	
