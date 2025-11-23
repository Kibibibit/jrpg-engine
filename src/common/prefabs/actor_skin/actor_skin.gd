extends Node3D
class_name ActorSkin

signal animation_event_frame
signal animation_finished

@export var animation_player: AnimationPlayer
@export var center_of_mass: Node3D
@export var above_head: Node3D
@export var weapon_left: Node3D
@export var weapon_right: Node3D

## TODO: This whole animation system needs a serious rework

const ANIM_IDLE: StringName = &"IDLE"
const ANIM_HURT: StringName = &"HURT"
const ANIM_HIT: StringName = &"HIT"
const ANIM_DODGE: StringName = &"DODGE"
const ANIM_DEAD: StringName = &"DEAD"
const ANIM_CAST: StringName = &"CAST"
const ANIM_ATTACK: StringName = &"ATTACK"

const INTERRUPTABLE: Dictionary[StringName, bool] = {
	ANIM_CAST: false,
	ANIM_ATTACK: false,
	ANIM_DODGE: false,
	ANIM_DEAD: false,
}

var idle_animation: StringName = ANIM_IDLE
var current_animation: StringName = ANIM_IDLE
var _awaiting_event: bool = false

var _get_idle_animation: Callable = _get_default_idle_animation

## Owner of an actor's 3d mesh and animation system

func _ready() -> void:
	play_animation(_get_idle_animation.call())
	animation_player.animation_finished.connect(_animation_finished)

func play_animation(animation_name: StringName) -> void:
	current_animation = animation_name
	if not animation_player.has_animation(current_animation):
		assert(not animation_player.get_animation_list().is_empty(), "No animations found for animation player!")
		var new_animation := animation_player.get_animation_list()[0]
		push_warning("missing animation %s, defaulting to %s" % [current_animation, new_animation])
		current_animation = StringName(new_animation)
		
	animation_player.play(current_animation)

func play_eventful_animation(animation_name: StringName) -> void:
	play_animation(animation_name)
	_awaiting_event = true
	await animation_event_frame


func play_hit_animation() -> void:
	play_animation(ANIM_HIT)

func play_dodge_animation() -> void:
	play_animation(ANIM_DODGE)

func play_dead_animation() -> void:
	play_animation(ANIM_DEAD)

func _on_event_frame() -> void:
	_awaiting_event = false
	animation_event_frame.emit()

func _animation_finished(anim: StringName):

	if _awaiting_event:
		push_warning("Animation finished before event frame was reached: %s" % anim)
		_on_event_frame()
		_awaiting_event = false

	animation_finished.emit()
	
	if anim != ANIM_DEAD:
		play_animation(_get_idle_animation.call())

## TODO: Work out when to use these, probably when the skill is selected, and then reset after the skill is done
func turn_towards(target_position: Vector3) -> void:
	look_at(target_position, Vector3.UP)
	rotation.x = 0.0
	rotation.z = 0.0

func reset_orientation() -> void:
	rotation = Vector3.ZERO

func set_get_idle_animation(fn: Callable) -> void:
	_get_idle_animation = fn

func _get_default_idle_animation() -> StringName:
	return ANIM_IDLE
func restart_animation() -> void:
	play_animation(_get_idle_animation.call())

func _check_is_animation_interruptable(anim: StringName) -> bool:
	if INTERRUPTABLE.has(anim):
		return INTERRUPTABLE[anim]
	else:
		return true
