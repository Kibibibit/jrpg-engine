extends Resource
class_name CharacterState

signal hp_updated
signal mp_updated

## Mutable data for character, such as current hp, mp, ailments, temporary weaknesses/buffs
## Used to save player character data

static func from_template(p_template: CharacterTemplate) -> CharacterState:
	var state = CharacterState.new()
	state.template = p_template
	state.stats = Stats.new()
	state.current_hp = p_template.get_base_stat(Stats.Type.MAX_HP)
	state.current_mp = p_template.get_base_stat(Stats.Type.MAX_MP)
	state.skills = p_template.get_innate_skills()
	return state

@export var current_hp: int = 0
@export var current_mp: int = 0

@export var template: CharacterTemplate
@export var stats: Stats

@export var ailments: Array[Ailment] = []

@export var skills: Array[Skill] = []

@export var is_defending: bool = false

var modifiers: Modifiers = Modifiers.new()

func get_display_name() -> String:
	## TODO: Support name overrides
	return template.display_name

func get_max_hp() -> int:
	return get_stat(Stats.Type.MAX_HP)

func get_current_hp() -> int:
	return current_hp

func get_max_mp() -> int:
	return get_stat(Stats.Type.MAX_MP)

func get_current_mp() -> int:
	return current_mp

func is_alive() -> bool:
	return current_hp > 0

func set_current_hp(amount: int) -> void:
	current_hp = clampi(amount, 0, get_max_hp())
	hp_updated.emit()

func set_current_mp(amount: int) -> void:
	current_mp = clampi(amount, 0, get_max_mp())
	mp_updated.emit()

func heal(amount: int) -> void:
	set_current_hp(current_hp + amount)

func damage(amount: int) -> void:
	set_current_hp(current_hp - amount)

func flip_allied_team() -> bool:
	return ailments.any(func(a: Ailment) -> bool:
		return a.flips_allies()
	)

func flip_enemy_team() -> bool:
	return ailments.any(func(a: Ailment) -> bool:
		return a.flips_enemies()
	)

func get_initiative() -> int:
	return self.get_stat(Stats.Type.SPEED)

func get_stat(stat_type: Stats.Type) -> int:
	return template.get_base_stat(stat_type) + stats.get_stat(stat_type)

func get_skills() -> Array[Skill]:
	var modified_skills = skills.duplicate()
	for ailment in ailments:
		modified_skills = ailment.modify_skill_list(modified_skills)
	return modified_skills

func get_skin_scene() -> PackedScene:
	return template.get_skin_scene()

func get_attack_skill() -> Skill:
	return template.get_attack_skill()

func get_elemental_affinity(element: Element.Type) -> Affinity.Type:
	## TODO: Items, Wall spells
	var affinity: Affinity.Type = template.get_elemental_affinity(element)
	for ailment in ailments:
		affinity = Affinity.get_higher_affinity(
			ailment.elemental_affinity_override(element), 
			affinity
		)
	## TODO: This might be better handled in the damage calculations
	if get_is_defending() and affinity == Affinity.WEAK:
		affinity = Affinity.NORMAL
	return affinity

func get_elemental_soft_affinity(element: Element.Type) -> float:
	var multiplier: float = template.get_elemental_soft_affinity(element)
	## TODO: Items, Ailments, so on
	return multiplier

func is_controllable() -> bool:
	return not ailments.any(func(a: Ailment) -> bool:
		return a.disables_player_control()
	)

func get_is_defending() -> bool:
	return is_defending

func set_is_defending(defending: bool) -> void:
	is_defending = defending

func get_attack_modifier() -> float:
	var attack_mod: float = modifiers.get_attack_modifier()
	for ailment in ailments:
		attack_mod += ailment.get_attack_modifier_bonus()
	return attack_mod

func get_defense_modifier() -> float:
	var defense_mod: float = modifiers.get_defense_modifier()
	for ailment in ailments:
		defense_mod += ailment.get_defense_modifier_bonus()
	return defense_mod

func get_speed_modifier() -> float:
	var speed_mod: float = modifiers.get_speed_modifier()
	for ailment in ailments:
		speed_mod += ailment.get_speed_modifier_bonus()
	return speed_mod

func get_critical_modifier() -> float:
	var crit_mod: float = modifiers.get_critical_modifier()
	for ailment in ailments:
		crit_mod += ailment.get_critical_modifier_bonus()
	return crit_mod

func get_ailment_modifier() -> float:
	var ailment_mod: float = modifiers.get_ailment_modifier()
	for ailment in ailments:
		ailment_mod += ailment.get_ailment_modifier_bonus()
	return ailment_mod

func pre_turn_update() -> void:
	## TODO: Pre turn ailment effects
	if is_defending:
		## TODO: Emit a signal to update animations
		is_defending = false


func post_turn_update() -> void:
	## TODO: Post turn ailment effects (Burn, Poison, Regen, so on)
	var remaining_ailments: Array[Ailment] = ailments.duplicate()
	for ailment in ailments:
		ailment.duration -= 1
		if ailment.duration <= 0:
			remaining_ailments.erase(ailment)
	ailments = remaining_ailments
