extends SkillEffect
class_name SkillEffectPass


func get_results(user: CharacterState, _targets: Array[CharacterState]) -> Array[SkillResult]:
	var result := SkillResultPass.new()
	result.target = user
	result.user = user
	return [result]
	
func can_use(_user: CharacterState, _possible_targets: Array[CharacterState]) -> bool:
	return true
