extends SkillResult
class_name SkillResultDamage



var hits: Array[Hit] = []
var timing: float = 0.0

func add_hit(hit: Hit) -> void:
	hits.append(hit)

func apply(skill_context: SkillContext) -> void:
	while not hits.is_empty():
		var hit: Hit = hits.pop_front()
		skill_context.do_hit(user, target, hit)
		if not hits.is_empty() and timing > 0.0:
			await GlobalTimers.wait(timing)

func is_critical() -> bool:
	for hit in hits:
		if hit.is_critical():
			return true
	return false
