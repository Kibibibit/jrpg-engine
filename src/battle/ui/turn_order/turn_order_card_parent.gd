extends Control
class_name TurnOrderCardParent

@export var parent: BattleUI

var signal_bus: BattleSignalBus
var battle_context: BattleContext

var cards: Dictionary[CharacterState, TurnOrderCard] = {}

func _ready() -> void:
	signal_bus = parent.signal_bus
	battle_context = parent.battle_context
	assert(signal_bus != null, "TurnOrderParent: signal_bus is undefined")
	assert(battle_context != null, "TurnOrderParent: battle_context is undefined")
	signal_bus.turn_order_changed.connect(_update_cards)
	_update_cards()

func _update_cards() -> void:
	var missing_characters: Array[CharacterState] = cards.keys().duplicate()
	
	for idx in range(len(battle_context.turn_order)):
		var character := battle_context.turn_order[idx]
		if character in missing_characters:
			missing_characters.erase(character)
		
		if character in cards:
			cards[character].index = idx
		else:
			var new_card := TurnOrderCard.create_new(idx, character)
			cards[character] = new_card
			add_child(new_card)

	for character in missing_characters:
		var card := cards[character]
		cards.erase(character)
		card.remove()
	
	for card in cards.values():
		card.animate()
	
