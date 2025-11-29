extends Ailment
class_name AilmentCharm

## TODO: AI affects

func get_ailment_id() -> StringName:
	return &"AILMENT_CHARM"

func flips_allies() -> bool:
	return true

func flips_enemies() -> bool:
	return true

func disables_player_control() -> bool:
	return true
