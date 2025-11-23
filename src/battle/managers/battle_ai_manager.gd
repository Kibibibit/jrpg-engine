extends Node
class_name BattleAIManager

@export var signal_bus: BattleSignalBus
@export var battle_context: BattleContext

const NOTHING: Skill = preload("uid://csstxyr5bvy3i")

func _ready() -> void:
	signal_bus.request_ai_character_turn.connect(_on_turn_request)
	

func _on_turn_request(character: CharacterState) -> void:
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
	
	signal_bus.on_skill_selected.emit(character, chosen_skill, targets)
