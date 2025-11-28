extends SkillResult
class_name SkillResultHeal

var amount: int

func apply(skill_context: SkillContext) -> void:
	skill_context.do_heal(user, target, amount)
