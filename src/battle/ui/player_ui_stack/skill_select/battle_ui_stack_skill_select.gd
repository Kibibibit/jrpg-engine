extends BattleUIStackNode
class_name BattleUIStackSkillSelect

const PACKED_SCENE = preload("uid://cr1nv3playdnl")

var character: CharacterState = null

@onready var skill_list_container: VBoxContainer = $CenterContainer/VBoxContainer


static func create_new(p_character: CharacterState) -> BattleUIStackSkillSelect:
	var ui_skill_select: BattleUIStackSkillSelect = PACKED_SCENE.instantiate()
	ui_skill_select.character = p_character
	return ui_skill_select


func activate() -> void:
	
	var all_skills: Array[Skill] = character.get_skills()

	var character_team: Team.Type = battle_context.get_character_team(character)

	var allied_team: Team.Type = character_team if not character.flip_allied_team() else Team.get_opposite(character_team)
	var enemy_team: Team.Type = Team.get_opposite(character_team) if not character.flip_enemy_team() else character_team
	
	var allied_characters: Array[CharacterState] = battle_context.get_team_characters(allied_team)
	var enemy_characters: Array[CharacterState] = battle_context.get_team_characters(enemy_team)
	
	var usable_skills: Array[Skill] = []
	for skill in all_skills:
		if SkillUtils.can_use(character, skill, allied_characters, enemy_characters):
			usable_skills.append(skill)

	for skill in all_skills:
		var is_usable: bool = skill in usable_skills
		var button: Button = _create_button(skill, is_usable)
		skill_list_container.add_child(button)

func deactivate() -> void:
	for child in skill_list_container.get_children():
		if child is Button:
			if child.pressed.is_connected(_select_skill):
				child.pressed.disconnect(_select_skill)
		child.queue_free()



func _create_button(skill: Skill, is_usable: bool) -> Button:
	var button: Button = Button.new()
	button.text = "%s (Cost: %s)" % [skill.get_display_name(), _get_skill_cost_string(skill)]
	button.disabled = not is_usable
	button.pressed.connect(_select_skill.bind(skill))
	return button

func _get_skill_cost_string(skill: Skill) -> String:
	var cost_string: String = ""

	var cost_amount: int = SkillUtils.calculate_cost(skill, character)
	if skill.cost_resource == CostResource.MP:
		cost_string += "%d MP" % cost_amount
	else:
		cost_string += "%d HP" % cost_amount
	return cost_string

func _select_skill(skill: Skill) -> void:
	push(BattleUIStackTargetSelect.create_new(character, skill))
