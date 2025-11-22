extends SkillResult
class_name SkillResultDefend

func apply(skill_context: SkillContext) -> void:
	skill_context.do_defend(user)
	
func is_critical() -> bool:
	return false
	
