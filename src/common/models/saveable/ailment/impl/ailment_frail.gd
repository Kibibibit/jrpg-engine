extends Ailment
class_name AilmentFrail

func get_ailment_id() -> StringName:
	return &"AILMENT_FRAIL"

func elemental_affinity_override(element: Element.Type) -> Affinity.Type:
	match element:
		Element.PIERCE, Element.BLUNT, Element.SLASH:
			return Affinity.WEAK
		_:
			return Affinity.NORMAL

func get_attack_modifier_bonus() -> float:
	return -0.1
