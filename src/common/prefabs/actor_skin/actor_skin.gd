extends Node3D
class_name ActorSkin

signal animation_finished
signal animation_event_frame

@export var animation_player: AnimationPlayer
@export var center_of_mass: Node3D
@export var above_head: Node3D
@export var weapon_left: Node3D
@export var weapon_right: Node3D

const ANIM_IDLE: StringName = &"IDLE"
const ANIM_HIT: StringName = &"HIT"
const ANIM_DODGE: StringName = &"DODGE"
const ANIM_DEAD: StringName = &"DEAD"
const ANIM_CAST: StringName = &"CAST"
const ANIM_ATTACK: StringName = &"ATTACK"

const INTERRUPTABLE: Dictionary[StringName, bool] = {
	ANIM_CAST: false,
	ANIM_ATTACK: false,
	ANIM_IDLE: true,
	ANIM_HIT: true,
	ANIM_DODGE: false,
	ANIM_DEAD: false,
}

var current_animation: StringName = ANIM_IDLE
var _awaiting_event: bool = false

## Owner of an actor's 3d mesh and animation system

func _ready() -> void:
	animation_player.play(ANIM_IDLE)
	animation_player.animation_finished.connect(_animation_finished)

func _play_animation(animation_name: StringName) -> void:
	if not INTERRUPTABLE[current_animation]:
		return
	current_animation = animation_name
	animation_player.play(animation_name)

func play_eventful_animation(animation_name: StringName) -> void:
	_play_animation(animation_name)
	_awaiting_event = true
	await animation_event_frame


func play_hit_animation() -> void:
	_play_animation(ANIM_HIT)

func play_dodge_animation() -> void:
	_play_animation(ANIM_DODGE)

func play_dead_animation() -> void:
	_play_animation(ANIM_DEAD)

func _on_event_frame() -> void:
	_awaiting_event = false
	animation_event_frame.emit()

func _animation_finished(anim: StringName):

	if _awaiting_event:
		push_warning("Animation finished before event frame was reached: %s" % anim)
		_on_event_frame()
		

	if anim != ANIM_DEAD:
		current_animation = ANIM_IDLE
		animation_player.play(ANIM_IDLE)

## TODO: Work out when to use these, probably when the skill is selected, and then reset after the skill is done
func turn_towards(target_position: Vector3) -> void:
	look_at(target_position, Vector3.UP)
	rotation.x = 0.0
	rotation.z = 0.0

func reset_orientation() -> void:
	rotation = Vector3.ZERO
