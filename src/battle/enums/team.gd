@abstract
extends RefCounted
class_name Team

enum Type {
	PLAYER,
	ENEMY
}

const PLAYER = Type.PLAYER
const ENEMY = Type.ENEMY

const TEAM_GROUP: Dictionary[Type, String] = {
	Type.PLAYER: Groups.PLAYER_BATTLE_ACTOR,
	Type.ENEMY: Groups.ENEMY_BATTLE_ACTOR,
}

static func get_opposite(p_team: Type) -> Type:
	if p_team == Type.PLAYER:
		return Type.ENEMY
	else:
		return Type.PLAYER

static func get_group(p_team: Type) -> String:
	return TEAM_GROUP[p_team]