extends BattleUIStackNode
class_name BattleUIStackTargetSelect

const PACKED_SCENE = preload("uid://cmeapmohuhlkn")

@onready var left_button: Button = %LeftButton
@onready var select_button: Button = %SelectButton
@onready var right_button: Button = %RightButton


var character: CharacterState = null
var skill: Skill = null

var _current_target: int = -1
var _possible_targets: Array[CharacterState] = []
var _reticles: Array[TargetReticle] = []

## TODO: Work out how to remove item from inventory on target select,
## if an item was being used

static func create_new(p_character: CharacterState, p_skill: Skill) -> BattleUIStackTargetSelect:
	var ui_target_select: BattleUIStackTargetSelect = PACKED_SCENE.instantiate()
	ui_target_select.character = p_character
	ui_target_select.skill = p_skill
	return ui_target_select

func _unhandled_input(event: InputEvent) -> void:
	## TODO: Actual actions instead of key checking
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			pop()

func activate() -> void:
	_calculate_possible_targets()

	if skill.target_scope == Skill.TargetScope.SINGLE:
		_current_target = 0
		var reticle: TargetReticle = TargetReticle.create_new()
		_reticles.append(reticle)
		add_child(reticle)
		reticle.set_target(_get_character_target_position(_possible_targets[_current_target]))
		left_button.visible = _possible_targets.size() > 1
		right_button.visible = _possible_targets.size() > 1
	else:
		left_button.visible = false
		right_button.visible = false
		for target in _possible_targets:
			var reticle: TargetReticle = TargetReticle.create_new()
			_reticles.append(reticle)
			add_child(reticle)
			reticle.set_target(_get_character_target_position(target))
	
	## TODO: Smarter cycling
	if not left_button.pressed.is_connected(_change_target):
		left_button.pressed.connect(_change_target.bind(-1))
	if not right_button.pressed.is_connected(_change_target):
		right_button.pressed.connect(_change_target.bind(1))
	
	if not select_button.pressed.is_connected(_confirm_target):
		select_button.pressed.connect(_confirm_target)


	_update_target_display_name()
	
	visible = true

func deactivate() -> void:
	_possible_targets.clear()
	visible = false
	if left_button.pressed.is_connected(_change_target):
		left_button.pressed.disconnect(_change_target)
	if right_button.pressed.is_connected(_change_target):
		right_button.pressed.disconnect(_change_target)
	if select_button.pressed.is_connected(_confirm_target):
		select_button.pressed.disconnect(_confirm_target)
	
	for child in get_children():
		if child is TargetReticle:
			child.queue_free()
	_reticles.clear()

func _get_character_target_position(p_character: CharacterState) -> Vector3:
	var battle_actor: BattleActor = battle_context.get_actor_from_character(p_character)
	return battle_actor.get_target_position(TargetPosition.CENTER_OF_MASS)

func _calculate_possible_targets() -> void:
	var character_team: Team.Type = battle_context.get_character_team(character)

	var allied_team: Team.Type = character_team if not character.flip_allied_team() else Team.get_opposite(character_team)
	var enemy_team: Team.Type = Team.get_opposite(character_team) if not character.flip_enemy_team() else character_team
	
	var allied_characters: Array[CharacterState] = battle_context.get_team_characters(allied_team)
	var enemy_characters: Array[CharacterState] = battle_context.get_team_characters(enemy_team)

	_possible_targets = SkillUtils.get_targets(skill, character, allied_characters, enemy_characters)


func _update_target_display_name() -> void:
	if _current_target >= 0 and skill.target_scope == Skill.TargetScope.SINGLE:
		select_button.text = _possible_targets[_current_target].get_display_name()
	elif skill.target_scope == Skill.TargetScope.SELF:
		select_button.text = character.get_display_name()
	else:
		select_button.text = "%d Characters" % _possible_targets.size()

	
func _change_target(direction: int) -> void:
	_current_target = wrapi(_current_target + direction, 0, _possible_targets.size())
	_reticles.front().set_target(_get_character_target_position(_possible_targets[_current_target]))
	_update_target_display_name()

func _confirm_target() -> void:
	var targets: Array[CharacterState] = []

	if skill.target_scope == Skill.TargetScope.SINGLE:
		targets = [_possible_targets[_current_target]]
	elif skill.target_scope == Skill.TargetScope.SELF:
		targets = [character]
	else:
		targets = _possible_targets
	
	signal_bus.on_skill_selected.emit(character, skill, targets)
	pop_until(func(node: BattleUIStackNode) -> bool:
		return node is BattleUIStackRoot
	)
