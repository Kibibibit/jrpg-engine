extends BattleUIStackNode
class_name BattleUIStackRoot

func _init() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func activate() -> void:
	if not signal_bus.request_player_character_turn.is_connected(_on_request):
		signal_bus.request_player_character_turn.connect(_on_request)

func deactivate() -> void:
	if signal_bus.request_player_character_turn.is_connected(_on_request):
		signal_bus.request_player_character_turn.disconnect(_on_request)

func _on_request(character: CharacterState) -> void:
	var ui_action_select: BattleUIStackActionSelect = BattleUIStackActionSelect.create_new(character)
	push(ui_action_select)
