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

func _check_actions_enabled() -> void:
	
	
	var allied_characters: Array[CharacterState] = battle_context.get_allied_characters(character)
	var enemy_characters: Array[CharacterState] = battle_context.get_enemy_characters(character)
	# Attack button check
	attack_button.disabled = true
	if SkillUtils.can_use(character, character.get_attack_skill(), allied_characters, enemy_characters):
		attack_button.disabled = false
	
	# Skill button check
	skill_button.disabled = true
	var all_skills: Array[Skill] = character.get_skills()
	for skill in all_skills:
		if SkillUtils.can_use(character, skill, allied_characters, enemy_characters):
			skill_button.disabled = false
	
	# Item Button check
	# TODO: Implement item checking
	item_button.disabled = true
	
	# Defend button check - cannot be disabled
	defend_button.disabled = false
	
	# Pass Button check
	# TODO: Implement pass and work out if it can be disabled
	pass_button.disabled = true


func activate() -> void:
	visible = true
	_check_actions_enabled()

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
	
