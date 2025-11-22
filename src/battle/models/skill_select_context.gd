extends RefCounted
class_name SkillSelectContext


var character: CharacterState
var learned_skills: Array[Skill]
var usable_skills: Array[Skill]
var allied_characters: Array[CharacterState]
var enemy_characters: Array[CharacterState]

func _init(
		p_character: CharacterState,
		p_learned_skills: Array[Skill],
		p_usable_skills: Array[Skill],
		p_allied_characters: Array[CharacterState],
		p_enemy_characters: Array[CharacterState]
	) -> void:
	character = p_character
	learned_skills = p_learned_skills
	usable_skills = p_usable_skills
	allied_characters = p_allied_characters
	enemy_characters = p_enemy_characters