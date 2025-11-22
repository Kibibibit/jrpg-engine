extends Control
class_name UIStackNode




signal on_push(s_new_node: UIStackNode)
signal on_pop()
signal on_pop_until(s_cond: Callable)

func _ready() -> void:
	name = get_script().get_global_name()

func enter() -> void:
	pass

func activate() -> void:
	pass

func deactivate() -> void:
	pass

func exit() -> void:
	pass

func step() -> void:
	pass

func push(new_node: UIStackNode) -> void:
	on_push.emit(new_node)

func pop() -> void:
	on_pop.emit()

func pop_until_name(p_name: String) -> void:
	pop_until(func(node: UIStackNode) -> bool:
		return node.name == p_name
	)

func pop_until(p_cond: Callable) -> void:
	on_pop_until.emit(p_cond)
