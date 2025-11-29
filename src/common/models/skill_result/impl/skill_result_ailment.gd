extends SkillResult
class_name SkillResultAilment

var ailment: Ailment
var succeeded: bool = false

func apply(skill_context: SkillContext) -> void:
	skill_context.apply_ailment(target, ailment, succeeded)
