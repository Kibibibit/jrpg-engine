extends Item
class_name ConsumableItem

@export var _skill_id: StringName

func get_skill() -> Skill:
	return load(UIDTable.lookup(_skill_id)) as Skill
