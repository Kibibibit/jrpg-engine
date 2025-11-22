extends Resource
class_name Skill


## TODO: Momentum powered-up versions

enum CostType {
	FLAT,
	PERCENTAGE
}

enum CostResource {
	HP,
	MP
}

enum TargetScope {
	SELF,
	SINGLE,
	RANDOM,
	ALL
}

enum TargetGrouping {
	PER_TARGET,
	ALL
}


@export var display_name: String


@export var target_scope: TargetScope = TargetScope.SINGLE
@export var targets_allies: bool = false
@export var targets_enemies: bool = true
@export var target_grouping: TargetGrouping = TargetGrouping.PER_TARGET
@export var target_position: TargetPosition.Type = TargetPosition.CENTER_OF_MASS
@export var min_random_targets: int = 1
@export var max_random_targets: int = 1
@export var cast_animation: StringName = &"CAST"
@export var timing: float = 0.0

@export var cost_amount: int
@export var cost_type: CostType = CostType.FLAT
@export var cost_resource: CostResource = CostResource.MP
## If true, and [cost_resource] is HP, the skill is allowed to kill the user.
@export var allowed_to_kill: bool = false

@export var effects: Array[SkillEffect] = []

@export var instance_scene_id: StringName

func get_display_name() -> String:
	return display_name


func get_instance_scene() -> PackedScene:
	return load(UIDTable.lookup(instance_scene_id))
