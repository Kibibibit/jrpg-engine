extends Control
class_name DamageNumberParent


@export var parent: BattleUI

var signal_bus: BattleSignalBus
var battle_context: BattleContext

func _ready() -> void:
	signal_bus = parent.signal_bus
	battle_context = parent.battle_context
	assert(signal_bus != null, "DamageNumberParent: signal_bus is undefined")
	assert(battle_context != null, "DamageNumberParent: battle_context is undefined")
	signal_bus.on_hit.connect(_on_hit)
	signal_bus.on_heal.connect(_on_heal)



func _on_hit(_user: CharacterState, target: CharacterState, hit: Hit) -> void:
	var type: DamageNumber.Type = DamageNumber.Type.NORMAL
	match hit.hit_type:
		Hit.HitType.NORMAL:
			type = DamageNumber.Type.NORMAL
		Hit.HitType.CRITICAL:
			type = DamageNumber.Type.CRITICAL
		Hit.HitType.MISS:
			type = DamageNumber.Type.MISS
		Hit.HitType.BLOCK:
			type = DamageNumber.Type.BLOCK
		Hit.HitType.RESIST:
			type = DamageNumber.Type.RESIST
		Hit.HitType.WEAK:
			type = DamageNumber.Type.WEAK
	_create_damage_number(target, hit.damage_amount, type)
		

func _on_heal(_user: CharacterState, target: CharacterState, amount: int) -> void:
	_create_damage_number(target, amount, DamageNumber.Type.HEAL)


func _create_damage_number(target: CharacterState, amount: int, type: DamageNumber.Type) -> void:
	var target_actor: BattleActor = battle_context.get_actor_from_character(target)
	var spawn_position: Vector2 =_unproject_actor_position(target_actor)
	var damage_number := DamageNumber.create_new(amount, type)
	add_child(damage_number)
	damage_number.global_position = spawn_position + Vector2.from_angle(randf_range(-2.0*PI, 2.0*PI)) * randf_range(10.0, 50.0)
	

func _unproject_actor_position(battle_actor: BattleActor) -> Vector2:
	return  get_viewport().get_camera_3d().unproject_position(battle_actor.global_position)
