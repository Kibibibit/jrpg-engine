extends RefCounted
class_name Modifiers

## TODO: Look into some kind of config for these
const ATTACK_BUFF_MULTIPLIER: float = 0.15
const ATTACK_DEBUFF_MULTIPLIER: float = 0.10
const DEFENSE_BUFF_MULTIPLIER: float = 0.15
const DEFENSE_DEBUFF_MULTIPLIER: float = 0.10
const SPEED_BUFF_MULTIPLIER: float = 0.15
const SPEED_DEBUFF_MULTIPLIER: float = 0.10
const CRITICAL_BUFF_MULTIPLIER: float = 0.05
const CRITICAL_DEBUFF_MULTIPLIER: float = 0.05
const AILMENT_BUFF_MULTIPLIER: float = 0.10
const AILMENT_DEBUFF_MULTIPLIER: float = 0.10



var attack_buff: int = 0
var defense_buff: int = 0
var speed_buff: int = 0
var critical_buff: int = 0
var ailment_buff: int = 0


func _get_multiplier(buff: int, buff_multiplier: float, debuff_multiplier: float) -> float:
	var multiplier: float = 1.0
	if buff > 0:
		multiplier += float(buff) * buff_multiplier
	elif buff < 0:
		multiplier += float(buff) * debuff_multiplier
	return multiplier

func get_attack_modifier() -> float:
	return _get_multiplier(attack_buff, ATTACK_BUFF_MULTIPLIER, ATTACK_DEBUFF_MULTIPLIER)

func get_defense_modifier() -> float:
	return _get_multiplier(defense_buff, DEFENSE_BUFF_MULTIPLIER, DEFENSE_DEBUFF_MULTIPLIER)

func get_speed_modifier() -> float:
	return _get_multiplier(speed_buff, SPEED_BUFF_MULTIPLIER, SPEED_DEBUFF_MULTIPLIER)

func get_critical_modifier() -> float:
	return _get_multiplier(critical_buff, CRITICAL_BUFF_MULTIPLIER, CRITICAL_DEBUFF_MULTIPLIER)

func get_ailment_modifier() -> float:
	return _get_multiplier(ailment_buff, AILMENT_BUFF_MULTIPLIER, AILMENT_DEBUFF_MULTIPLIER)
