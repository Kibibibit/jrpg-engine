extends SkillEffect
class_name SkillEffectDamage

@export var power: int
@export var damage_variance: float = 0.0
@export var base_stat: Stats.Type
@export var element: Element.Type
@export var can_crit: bool = false
@export var crit_chance: float = 0.0
@export var can_miss: bool = true
@export var accuracy: float = 1.0

@export var min_hits: int = 1
@export var max_hits: int = 1
@export var hit_timing: float = 0.0



func get_results(user: CharacterState, targets: Array[CharacterState]) -> Array[SkillResult]:
	
	var results: Array[SkillResult] = []

	for intended_target in targets:
		results.append_array(_get_result_targets(user, intended_target))
	
	return results

func can_use(_user: CharacterState, possible_targets: Array[CharacterState]) -> bool:
	for target in possible_targets:
		if target.is_alive():
			return true
	return false

func _get_result_targets(user: CharacterState, intended_target: CharacterState) -> Array[SkillResult]:

	var results: Array[SkillResult] = []

	var num_hits: int = min_hits
	if min_hits != max_hits:
		num_hits = randi_range(min_hits, max_hits)

	
	var target_affinity: Affinity.Type = intended_target.get_elemental_affinity(element)
	var target: CharacterState = intended_target
	var reflected: bool = false
	if target_affinity == Affinity.REFLECT:
		target = user
		reflected = true
		target_affinity = target.get_elemental_affinity(element)
	
	var final_power: float = BattleCalculator.calculate_final_effect_power(user, target, base_stat, float(power), element, reflected)


	var result: SkillResultDamage = SkillResultDamage.new()
	result.user = user
	result.target = intended_target
	result.timing = hit_timing
	for i in num_hits:
		_get_hits_result(result, target_affinity, reflected, final_power)
	results.append(result)
	

	return results

func _get_hits_result(result: SkillResultDamage, target_affinity: Affinity.Type, reflected: bool, final_power: float) -> void:

	var hit: Hit = Hit.new()

	if can_miss:
		if randf() > BattleCalculator.calculate_hit_accuracy(result.user, result.target, accuracy):
			hit.hit_type = Hit.HitType.MISS
			result.add_hit(hit)
			return
	

	if target_affinity == Affinity.WEAK:
		hit.hit_type = Hit.HitType.WEAK
	elif target_affinity == Affinity.RESIST:
		hit.hit_type = Hit.HitType.RESIST
	elif target_affinity == Affinity.BLOCK:
		hit.hit_type = Hit.HitType.BLOCK
	elif target_affinity == Affinity.REFLECT and reflected:
		# Block reflected hits, to prevent infinite reflections
		hit.hit_type = Hit.HitType.BLOCK

	var is_crit: bool = false
	if can_crit:
		if randf() < BattleCalculator.calculate_crit_chance(result.user, result.target, crit_chance):
			hit.hit_type = Hit.HitType.CRITICAL
			is_crit = true
	
	var damage: int = BattleCalculator.calculate_hit_damage(
		final_power, 
		is_crit, 
		damage_variance
	)
		
	hit.reflected = reflected
	hit.damage_amount = damage

	result.add_hit(hit)
