extends SkillEffect
class_name SkillEffectAilment


@export var ailment_chance: float = 0.5
@export var ailment: Ailment

func get_results(user: CharacterState, targets: Array[CharacterState]) -> Array[SkillResult]:
	var results: Array[SkillResult] = []
	
	for target in targets:
		var final_ailment_chance: float = BattleCalculator.calculate_ailment_chance(
			user,
			target,
			ailment_chance
		)
		
		var result := SkillResultAilment.new()
		result.ailment = ailment
		result.target = target
		result.user = user
		if randf() < final_ailment_chance:
			result.succeeded = true
			

		results.append(result)
	
	return results

func can_use(_user: CharacterState, possible_targets: Array[CharacterState]) -> bool:
	for target in possible_targets:
		if target.is_alive():
			return true
	return false
