extends Resource
class_name CharacterTemplate

## Template data for a character, so base stats, base level, skills and other data

@export var display_name: String
@export var base_stats: Stats

@export var innate_skills: Array[Skill] = []

@export var elemental_affinities: Dictionary[Element.Type, Affinity.Type] = {}

## Optional damage multipliers for elements, these can be used to 
## make characters take even more or less damage from certain elements,
## without triggering the effects of Resist, Block, Absorb, etc.
## This multiplier is applied to the final power, before any variance, crit or other affinity
## calculations.
@export var elemental_soft_affinities: Dictionary[Element.Type, float] = {}

@export var skin_scene_id: StringName
@export var attack_skill_id: StringName

func get_base_stat(stat_type: Stats.Type) -> int:
	return base_stats.get_stat(stat_type)

func get_innate_skills() -> Array[Skill]:
	return innate_skills.duplicate()

func get_skin_scene() -> PackedScene:
	return load(UIDTable.lookup(skin_scene_id))

func get_elemental_affinity(element: Element.Type) -> Affinity.Type:
	if elemental_affinities.has(element):
		return elemental_affinities[element]
	else:
		return Affinity.NORMAL

func get_elemental_soft_affinity(element: Element.Type) -> float:
	if elemental_soft_affinities.has(element):
		return elemental_soft_affinities[element]
	else:
		return 1.0
	
func get_attack_skill() -> Skill:
	return load(UIDTable.lookup(attack_skill_id))
