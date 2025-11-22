extends SkillResult
class_name SkillResultHeal

var amount: int

func apply(skill_context: SkillContext) -> void:
	skill_context.do_heal(user, target, amount)

func is_critical() -> bool:
	# Healing cannot be critical
	return false
