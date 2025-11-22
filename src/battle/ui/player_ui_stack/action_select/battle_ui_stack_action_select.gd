extends BattleUIStackNode
class_name BattleUIStackActionSelect

const PACKED_SCENE = preload("uid://mag2061hs3vw")

## TODO: Check if we want character specific defends?
const DEFEND_SKILL: Skill = preload("uid://ccrpmqx65jvdm")


@export var attack_button: Button
@export var skill_button: Button
@export var item_button: Button
@export var defend_button: Button
@export var pass_button: Button

var character: CharacterState = null

## TODO: On activate, validate if there are valid targets to attack, maybe?
## Unsure if there will ever be a case where there are not
## TODO: Validate if any items are available, disable item button if not

static func create_new(p_character: CharacterState) -> BattleUIStackActionSelect:
	var ui_action_select: BattleUIStackActionSelect = PACKED_SCENE.instantiate()
	ui_action_select.character = p_character
	return ui_action_select


func _ready() -> void:
	attack_button.pressed.connect(_on_attack_button_pressed)
	skill_button.pressed.connect(_on_skill_button_pressed)
	item_button.pressed.connect(_on_item_button_pressed)
	defend_button.pressed.connect(_on_defend_button_pressed)
	pass_button.pressed.connect(_on_pass_button_pressed)

func _disable_skill_button() -> bool:
	## TODO: Move this somewhere
	var all_skills: Array[Skill] = character.get_skills()

	var character_team: Team.Type = battle_context.get_character_team(character)

	var allied_team: Team.Type = character_team if not character.flip_allied_team() else Team.get_opposite(character_team)
	var enemy_team: Team.Type = Team.get_opposite(character_team) if not character.flip_enemy_team() else character_team
	
	var allied_characters: Array[CharacterState] = battle_context.get_team_characters(allied_team)
	var enemy_characters: Array[CharacterState] = battle_context.get_team_characters(enemy_team)
	
	for skill in all_skills:
		if SkillUtils.can_use(character, skill, allied_characters, enemy_characters):
			return false
	return true

func activate() -> void:
	visible = true
	item_button.disabled = true ## TODO: Check for items
	skill_button.disabled = _disable_skill_button()

func deactivate() -> void:
	visible = false

func _on_attack_button_pressed() -> void:
	var skill: Skill = character.get_attack_skill()
	var ui_target_select := BattleUIStackTargetSelect.create_new(character, skill)
	push(ui_target_select)

func _on_skill_button_pressed() -> void:
	var ui_skill_select := BattleUIStackSkillSelect.create_new(character)
	push(ui_skill_select)

func _on_item_button_pressed() -> void:
	## TODO: Push item select
	pass

func _on_defend_button_pressed() -> void:
	var skill: Skill = DEFEND_SKILL
	var ui_target_select: BattleUIStackTargetSelect = BattleUIStackTargetSelect.create_new(character, skill)
	push(ui_target_select)

func _on_pass_button_pressed() -> void:
	## TODO: Push confirm? Either confirm or just use straight away
	pass
	
