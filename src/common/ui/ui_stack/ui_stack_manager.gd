extends Control
class_name UIStackManager



var _current_node: UIStackNode:
	get:
		if get_child_count() == 0:
			return null
		return get_child(-1) as UIStackNode


## Pre-push hook that can be overwritten
func _on_node_enter() -> void:
	pass


func begin():
	if not _current_node:
		push_error("UIStackManager has no initial state!")
		return
	_connect_signals()
	_on_node_enter()
	_current_node.enter()
	_current_node.activate()


func push_node(p_node: UIStackNode) -> void:
	if _current_node:
		_current_node.deactivate()
	_disconnect_signals()
	add_child(p_node)
	_on_node_enter()
	_current_node.enter()
	_current_node.activate()
	_connect_signals()

func pop_node() -> void:
	if not _current_node:
		return
	_disconnect_signals()
	_current_node.deactivate()
	_current_node.exit()
	_current_node.queue_free()
	remove_child(_current_node)
	_connect_signals()
	if _current_node:
		_current_node.activate()

func pop_node_until(p_cond: Callable) -> void:
	if not _current_node:
		return
	_disconnect_signals()
	while not p_cond.call(_current_node):
		if not _current_node:
			push_error("Never found a state matching condition")
			return
		_current_node.exit()
		_current_node.queue_free()
		remove_child(_current_node)
		
	_connect_signals()
	if _current_node:
		_current_node.activate()
		

func step() -> void:
	if _current_node:
		_current_node.step()

func _disconnect_signals() -> void:
	if _current_node:
		_current_node.on_push.disconnect(push_node)
		_current_node.on_pop.disconnect(pop_node)
		_current_node.on_pop_until.disconnect(pop_node_until)

func _connect_signals() -> void:
	if _current_node:
		_current_node.on_push.connect(push_node)
		_current_node.on_pop.connect(pop_node)
		_current_node.on_pop_until.connect(pop_node_until)

	
