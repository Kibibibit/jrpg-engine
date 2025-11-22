extends Node3D
class_name Formation


@export var slots: Array[Node3D] = []

## TODO: Needs a refactor to allow dynamic enemy counts
func add_actor(actor: BattleActor) -> void:
	for slot in slots:
		if slot.get_child_count() == 0:
			slot.add_child(actor)
			return
	
	push_error("no free slots to add actor too")
	
