extends Ailment
class_name AilmentCharm

## TODO: AI affects

func flips_allies() -> bool:
	return true

func flips_enemies() -> bool:
	return true

func disables_player_control() -> bool:
	return true
