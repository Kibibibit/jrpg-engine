@abstract
extends RefCounted
class_name SkillUtils



static func get_targets(
	skill: Skill, 
	user: CharacterState, 
	allied_characters: Array[CharacterState],
	enemy_characters: Array[CharacterState]
) -> Array[CharacterState]:
	var possible_targets: Array[CharacterState] = []
	
	if skill.target_scope == Skill.TargetScope.SELF:
		return [user]
	if skill.targets_allies:
		for effect in skill.effects:
			for target in allied_characters:
				if effect.can_use(user, [target]):
					possible_targets.append(target)
	if skill.targets_enemies:
		for effect in skill.effects:
			for target in enemy_characters:
				if effect.can_use(user, [target]):
					possible_targets.append(target)
	
	return possible_targets
	
static func get_user_resource_total(skill: Skill, user: CharacterState) -> int:
	if skill.cost_resource == Skill.CostResource.MP:
		return user.get_current_mp()
	else:
		return user.get_current_hp()

static func calculate_cost(skill: Skill, user: CharacterState) -> int:
	var base_cost: float = float(skill.cost_amount)
	var user_total: float = float(SkillUtils.get_user_resource_total(skill, user))
	if skill.cost_type == Skill.CostType.PERCENTAGE:
		return floori(base_cost * (user_total / 100.0))
	else:
		return floori(base_cost)

static func can_use(user: CharacterState, skill: Skill, allies: Array[CharacterState], enemies: Array[CharacterState]) -> bool:
	var skill_cost: int = SkillUtils.calculate_cost(skill, user)
	var user_total_resource: int = SkillUtils.get_user_resource_total(skill, user)

	if skill.cost_resource == Skill.CostResource.MP or skill.allowed_to_kill:
		if user_total_resource < skill_cost:
			return false
	else:
		if user_total_resource <= skill_cost:
			return false

	var possible_targets: Array[CharacterState] = SkillUtils.get_targets(skill, user, allies, enemies)
	for effect in skill.effects:
		if not effect.can_use(user, possible_targets):
			return false
	return true
