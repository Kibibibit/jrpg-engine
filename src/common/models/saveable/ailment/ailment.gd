@abstract
extends Resource
class_name Ailment

@export var duration: int = 0

## TODO: AI behaviour, damage
## TODO: Work out how ailments will stack

@abstract
func get_ailment_id() -> StringName

func flips_allies() -> bool:
	return false

func flips_enemies() -> bool:
	return false

func disables_player_control() -> bool:
	return false

func modify_skill_list(skills: Array[Skill]) -> Array[Skill]:
	return skills

func elemental_affinity_override(_element: Element.Type) -> Affinity.Type:
	return Affinity.NORMAL

func get_attack_modifier_bonus() -> float:
	return 0.0

func get_defense_modifier_bonus() -> float:
	return 0.0

func get_speed_modifier_bonus() -> float:
	return 0.0

func get_critical_modifier_bonus() -> float:
	return 0.0

func get_ailment_modifier_bonus() -> float:
	return 0.0
