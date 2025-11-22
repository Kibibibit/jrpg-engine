extends SkillEffect
class_name SkillEffectHeal

enum HealType {
	FLAT,
	PERCENTAGE
}

@export var power: int
@export var base_stat: Stats.Type
@export var heal_type: HealType = HealType.FLAT

func get_results(user: CharacterState, targets: Array[CharacterState]) -> Array[SkillResult]:
	
	var total_power: float = float(power)
	var user_stat: float = float(user.get_stat(base_stat))

	## TODO: Maybe make this 0.01 configurable
	total_power *= (1.0 + user_stat * 0.01)

	var results: Array[SkillResult] = []
	for target in targets:
		var heal_amount: int = 0
		if heal_type == HealType.FLAT:
			heal_amount = floori(total_power)
		elif heal_type == HealType.PERCENTAGE:
			total_power /= 100.0
			heal_amount = floori(total_power * float(target.get_max_hp()))

		## TODO: Actual constructor
		var result: SkillResultHeal = SkillResultHeal.new()
		result.amount = heal_amount
		result.user = user
		result.target = target
		results.append(result)
	return results

func can_use(_user: CharacterState, possible_targets: Array[CharacterState]) -> bool:
	for target in possible_targets:
		if target.is_alive() and target.current_hp < target.get_max_hp():
			return true
	return false
