extends Node3D
class_name BattleSkillManager

## Small helper class to group skill results. Primarily exists
## because GDScript does not support typed nested arrays
class SkillResultSet extends RefCounted:
	var results: Array[SkillResult] = []
	var targets: Array[CharacterState] = []
	var is_critical: bool = false


@export var signal_bus: BattleSignalBus = null
@export var battle_context: BattleContext = null

var all_instances_created: bool = false

var instances: Array[SkillInstance] = []

func _ready() -> void:
	assert(signal_bus != null, "BattleSkillManager: signal_bus is null")
	assert(battle_context != null, "BattleSkillManager: battle_context is null")
	signal_bus.request_execute_skill.connect(_on_request_execute_skill)

func _on_request_execute_skill(user: CharacterState, skill: Skill, targets: Array[CharacterState]) -> void:

	print("%s used %s" % [user.get_display_name(), skill.get_display_name()])
	all_instances_created = false

	var results: Array[SkillResultSet] = []

	var is_critical: bool = false
		

	if skill.target_grouping == Skill.TargetGrouping.PER_TARGET:
		for target in targets:
			var single_target: Array[CharacterState] = [target]
			var result_set: SkillResultSet = _get_result_set(user, skill, single_target)
			if result_set.is_critical:
				is_critical = true
			results.append(result_set)
	else:
		var result_set: SkillResultSet = _get_result_set(user, skill, targets)
		if result_set.is_critical:
			is_critical = true
		results.append(result_set)
		
	## TODO: Play a different animation on crit
	if skill.cast_animation_type != Skill.CastAnimationType.NONE:
		signal_bus.request_animation.emit(
			user, 
			skill.cast_animation,
			skill.cast_animation_type == Skill.CastAnimationType.EVENTFUL
		)
		await signal_bus.on_animation_event

	for result_set in results:
		_create_skill_instance(user, skill, result_set)
		if skill.timing > 0.0:
			await GlobalTimers.wait(skill.timing)
	
	all_instances_created = true
	_check_all_instances_finished() ## Check in case instances finished before this flag was set

func _get_result_set(user: CharacterState, skill: Skill, targets: Array[CharacterState]) -> SkillResultSet:
	assert(targets.size() > 0, "BattleSkillManager: No targets provided for skill result set")
	var output: SkillResultSet = SkillResultSet.new()
	output.targets = targets

	for effect in skill.effects:
		var effect_results: Array[SkillResult] = effect.get_results(user, targets)
		for result in effect_results:
			output.results.append(result)
			if result.is_critical():
				output.is_critical = true
	return output
				



func _create_skill_instance(_user: CharacterState, skill: Skill, result_set: SkillResultSet) -> void:
	assert(result_set.targets.size() > 0, "BattleSkillManager: No targets provided for skill instance")
	var scene: PackedScene = skill.get_instance_scene()
	var instance: SkillInstance = scene.instantiate() as SkillInstance
	instance.skill_context = BattleSkillContext.new(signal_bus)
	var target_position := Vector3.ZERO
	for target in result_set.targets:
		var target_actor: BattleActor = battle_context.get_actor_from_character(target)
		target_position += target_actor.get_target_position(skill.target_position)

	instance.target_position = target_position / float(result_set.targets.size())
	instance.targets = result_set.targets
	instance.results = result_set.results
	instances.append(instance)
	
	instance.on_finished.connect(_on_instance_finished, CONNECT_ONE_SHOT)
	add_child(instance)
	instance.play()

func _on_instance_finished(instance: SkillInstance) -> void:
	instances.erase(instance)
	_check_all_instances_finished()

func _check_all_instances_finished() -> void:
	if instances.is_empty() and all_instances_created:
		signal_bus.all_skill_instances_finished.emit()
