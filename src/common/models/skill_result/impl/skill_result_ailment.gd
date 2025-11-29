extends SkillResult
class_name SkillResultAilment

var ailment: Ailment

func apply(skill_context: SkillContext) -> void:
	skill_context.apply_ailment(target, ailment)
