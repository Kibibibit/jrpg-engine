extends SkillEffect
class_name SkillEffectNothing


func get_results(user: CharacterState, _targets: Array[CharacterState]) -> Array[SkillResult]:
	return [SkillResultNothing.new(user)]

func can_use(_user: CharacterState, _possible_targets: Array[CharacterState]) -> bool:
	return true
