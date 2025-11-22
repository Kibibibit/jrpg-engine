extends UIStackManager
class_name BattleUIStackManager

@export var parent: BattleUI

var battle_context: BattleContext
var signal_bus: BattleSignalBus

func _init() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _ready() -> void:
	signal_bus = parent.signal_bus
	battle_context = parent.battle_context
	assert(signal_bus != null, "BattleUIStackManager: signal_bus is undefined")
	assert(battle_context != null, "BattleUIStackManager: battle_context is undefined")
	
	begin()

func _on_node_enter() -> void:
	if (_current_node is BattleUIStackNode):
		_current_node.battle_context = battle_context
		_current_node.signal_bus = signal_bus
	
