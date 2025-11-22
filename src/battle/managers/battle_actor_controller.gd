extends Node
class_name BattleActorController

## TODO: Look into refactoring this class out, or renaming it, as this controls battle flow
## more than it does actors now

@export var battle_context: BattleContext = null
@export var signal_bus: BattleSignalBus = null

const NOTHING: Skill = preload("uid://csstxyr5bvy3i")

func _ready() -> void:
	assert(battle_context != null, "BattleActorController: battle_context is null")
	assert(signal_bus != null, "BattleActorController: signal_bus is null")

	signal_bus.request_character_turn.connect(_on_request_character_turn)
	signal_bus.request_apply_skill_cost.connect(_on_request_apply_skill_cost)
	signal_bus.on_skill_selected.connect(_execute_skill)

func _on_request_character_turn(character: CharacterState) -> void:
	var learned_skills: Array[Skill] = character.get_skills()

	var character_team: Team.Type = battle_context.get_character_team(character)

	var allied_team: Team.Type = character_team if not character.flip_allied_team() else Team.get_opposite(character_team)
	var enemy_team: Team.Type = Team.get_opposite(character_team) if not character.flip_enemy_team() else character_team

	var allied_characters: Array[CharacterState] = battle_context.get_team_characters(allied_team)
	var enemy_characters: Array[CharacterState] = battle_context.get_team_characters(enemy_team)

	var usable_skills: Array[Skill] = []
	for skill in learned_skills:
		if SkillUtils.can_use(character, skill, allied_characters, enemy_characters):
			usable_skills.append(skill)
	if not enemy_characters.is_empty():
		usable_skills.append(character.get_attack_skill())
	
	if usable_skills.size() == 0:
		usable_skills = [NOTHING]
	
	## TODO: Refactor out this into the AI controller
	var skill_select_context: SkillSelectContext = SkillSelectContext.new(
		character,
		learned_skills,
		usable_skills,
		allied_characters,
		enemy_characters
	)

	
	if character_team == Team.PLAYER and character.is_controllable():
		signal_bus.request_player_character_turn.emit(character)
	else:
		_get_ai_skill(skill_select_context)
	



func _on_request_apply_skill_cost(user: CharacterState, resource: Skill.CostResource, amount: int) -> void:
	if resource == Skill.CostResource.MP:
		user.set_current_mp(user.get_current_mp() - amount)
	else:
		user.set_current_hp(user.get_current_hp() - amount)


func _get_ai_skill(
	skill_select_context: SkillSelectContext
) -> void:
	var character: CharacterState = skill_select_context.character
	var usable_skills: Array[Skill] = skill_select_context.usable_skills
	var allied_characters: Array[CharacterState] = skill_select_context.allied_characters
	var enemy_characters: Array[CharacterState] = skill_select_context.enemy_characters
	## TODO: Actual AI
	var chosen_skill: Skill = usable_skills.pick_random()

	var targets: Array[CharacterState] = SkillUtils.get_targets(chosen_skill, character, allied_characters, enemy_characters)

	if chosen_skill.target_scope == Skill.TargetScope.SELF:
		targets = [character]
	elif chosen_skill.target_scope == Skill.TargetScope.SINGLE:
		targets = [targets.pick_random()]
	elif chosen_skill.target_scope == Skill.TargetScope.RANDOM:
		var new_targets: Array[CharacterState] = []
		for i in randi_range(chosen_skill.min_random_targets, chosen_skill.max_random_targets):
			new_targets.append(targets.pick_random())
		targets = new_targets
	
	_execute_skill(character, chosen_skill, targets)

func _execute_skill(character: CharacterState, skill: Skill, targets: Array[CharacterState]) -> void:
	signal_bus.request_apply_skill_cost.emit(character, skill.cost_resource, SkillUtils.calculate_cost(skill, character))
	signal_bus.request_execute_skill.emit(character, skill, targets)
