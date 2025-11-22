extends SkillEffect
class_name SkillEffectDefend


func get_results(user: CharacterState, _targets: Array[CharacterState]) -> Array[SkillResult]:
	var results: Array[SkillResult] = []
	var result: SkillResultDefend = SkillResultDefend.new()
	result.user = user
	result.target = user
	results.append(result)
	return results
	
func can_use(_user: CharacterState, _possible_targets: Array[CharacterState]) -> bool:
	return true
