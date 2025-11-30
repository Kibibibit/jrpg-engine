extends Ailment
class_name AilmentBeserk

## TODO: Better resource lookup for this
var SKILL_FRENZY: Skill = load(UIDTable.lookup(&"skill/frenzy"))


func flips_allies() -> bool:
	return true
	
func modify_skill_list(skills: Array[Skill]) -> Array[Skill]:
	skills = [SKILL_FRENZY]
	return skills

func get_attack_modifier_bonus() -> float:
	return 0.1

func get_defense_modifier_bonus() -> float:
	return -0.1

func get_critical_modifier_bonus() -> float:
	return 0.05
