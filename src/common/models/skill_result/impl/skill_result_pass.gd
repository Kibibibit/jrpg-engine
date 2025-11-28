extends SkillResult
class_name SkillResultPass



func apply(skill_context: SkillContext) -> void:
	skill_context.do_pass(user)
