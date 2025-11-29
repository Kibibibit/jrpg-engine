@abstract
extends RefCounted
class_name BattleCalculator


static func _get_affinity_multiplier(affinity: Affinity.Type) -> float:
	match affinity:
		Affinity.WEAK:
			return 1.5
		Affinity.RESIST:
			return 0.5
		Affinity.BLOCK:
			return 0.0
		Affinity.ABSORB:
			return -1.0
		_:
			return 1.0


static func calculate_final_effect_power(
	user: CharacterState, 
	target: CharacterState,
	base_stat: Stats.Type,
	base_power: float,
	element: Element.Type, 
	reflected: bool
) -> float:

	## TODO: Buffs and debuffs

	var target_affinity: Affinity.Type = target.get_elemental_affinity(element)
	var target_soft_affinity: float = target.get_elemental_soft_affinity(element)


	var attack_stat: float = float(user.get_stat(base_stat)) * user.get_attack_modifier()

	var defense_stat: float = float(target.get_stat(Stats.Type.DEFENSE)) * target.get_defense_modifier()

	## TODO: Consider a more complex formula
	var final_power: float = base_power * (1.0 - defense_stat * 0.01) * (1.0 + attack_stat * 0.01)
	
	if target.is_defending:
		final_power *= 0.75 ## TODO: Make this configurable

	var affinity_multiplier: float = _get_affinity_multiplier(target_affinity) * target_soft_affinity
	if reflected and target_affinity == Affinity.REFLECT:
		affinity_multiplier = 0.0
	
	
	final_power *= affinity_multiplier

	return final_power


static func calculate_hit_damage(
	effect_power: float,
	is_crit: bool,
	damage_variance: float
) -> int:
	var base_damage: float = effect_power

	if damage_variance > 0.0:
		var variance_amount: float = base_damage * damage_variance
		variance_amount = randf_range(-variance_amount, variance_amount)
		base_damage += variance_amount
	
	if is_crit:
		## TODO: Configurable critical multiplier
		base_damage *= 2.0

	return int(round(base_damage))


static func calculate_hit_accuracy(
	user: CharacterState,
	target: CharacterState,
	accuracy: float
) -> float:
	## TODO: New formula
	var user_speed: float = float(user.get_stat(Stats.Type.SPEED)) * user.get_speed_modifier()
	var target_speed: float = float(target.get_stat(Stats.Type.SPEED)) * target.get_speed_modifier()
	
	var final_accuracy: float = accuracy * (1.0 + (user_speed - target_speed) * 0.005)

	return clamp(final_accuracy, 0.0, 1.0)

static func calculate_crit_chance(
	user: CharacterState,
	target: CharacterState,
	base_crit_chance: float
) -> float:

	## TODO: New formula
	var user_luck: float = float(user.get_stat(Stats.Type.LUCK)) * user.get_critical_modifier()
	var target_luck: float = float(target.get_stat(Stats.Type.LUCK)) * target.get_critical_modifier()

	var final_chance: float = base_crit_chance + (user_luck - target_luck) * 0.002

	return clamp(final_chance, 0.0, 1.0)

static func calculate_ailment_chance(
	user: CharacterState,
	target: CharacterState,
	base_ailment_chance: float
) -> float:
	
	## TODO: New formula
	## TODO: Ailment affinities maybe?
	var user_luck: float = float(user.get_stat(Stats.Type.LUCK)) * user.get_critical_modifier()
	var target_luck: float = float(target.get_stat(Stats.Type.LUCK)) * target.get_critical_modifier()

	var final_chance: float = base_ailment_chance + (user_luck - target_luck) * 0.002

	return clamp(final_chance, 0.0, 1.0)
