extends Node
class_name BattleContext

var character_states: Dictionary[int, CharacterState] = {}
var character_state_id_to_actor: Dictionary[int, BattleActor] = {}
var character_state_id_to_team: Dictionary[int, Team.Type] = {}

var turn_order: Array[CharacterState] = []

func get_characters(alive_only: bool = false) -> Array[CharacterState]:
	var characters: Array[CharacterState] = []
	for value in character_states.values():
		if not alive_only or value.is_alive():
			characters.append(value)
	return characters


func get_character_ids() -> Array[int]:
	var character_ids: Array[int] = []
	for key in character_states.keys():
		character_ids.append(key)
	return character_ids

func register_actor(p_actor: BattleActor, p_team: Team.Type) -> void:
	assert(not character_states.has(p_actor.get_character_id()), "Duplicate actor registered for character id %d" % p_actor.get_character_id())
	character_states[p_actor.get_character_id()] = p_actor.character_state
	character_state_id_to_actor[p_actor.get_character_id()] = p_actor
	character_state_id_to_team[p_actor.get_character_id()] = p_team

func get_character_team(p_character: CharacterState) -> Team.Type:
	assert(character_state_id_to_actor.has(p_character.get_instance_id()), "Character %s not found" % [p_character.get_display_name()])
	return character_state_id_to_team[p_character.get_instance_id()]

func get_team_characters(team: Team.Type) -> Array[CharacterState]:
	var characters: Array[CharacterState] = []
	for character_id in character_state_id_to_team.keys():
		if character_state_id_to_team[character_id] == team:
			var character_state = get_character_from_id(character_id)
			characters.append(character_state)
	return characters

func get_character_from_id(p_character_id: int) -> CharacterState:
	assert(character_states.has(p_character_id), "Character with id %d not found" % p_character_id)
	return character_states[p_character_id]

func get_actor_from_character(p_character: CharacterState) -> BattleActor:
	assert(character_state_id_to_actor.has(p_character.get_instance_id()), "Character with id %d not found" % p_character.get_instance_id())
	return character_state_id_to_actor[p_character.get_instance_id()]

func get_actor_from_character_id(p_character_id: int) -> BattleActor:
	assert(character_state_id_to_actor.has(p_character_id), "Character with id %d not found" % p_character_id)
	return character_state_id_to_actor[p_character_id]
