extends Resource
class_name Stats

enum Type {
	MAX_HP,
	MAX_MP,
	STRENGTH,
	MAGIC,
	DEFENSE,
	SPEED,
	LUCK
}

@export var max_hp: int = 0
@export var max_mp: int = 0
@export var strength: int = 0
@export var magic: int = 0
@export var defense: int = 0
@export var speed: int = 0
@export var luck: int = 0

func get_stat(stat_type: Type) -> int:
	match stat_type:
		Type.MAX_HP:
			return max_hp
		Type.MAX_MP:
			return max_mp
		Type.STRENGTH:
			return strength
		Type.MAGIC:
			return magic
		Type.DEFENSE:
			return defense
		Type.SPEED:
			return speed
		Type.LUCK:
			return luck
	push_error("Invalid stat type")
	return 0
