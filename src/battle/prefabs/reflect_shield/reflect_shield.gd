extends Node3D
class_name ReflectShield


const DURATION: float = 0.5

const PACKED_SCENE := preload("uid://ctspoli8gsewm")

var _tween: Tween

static func create_new() -> ReflectShield:
	var reflect_shield: ReflectShield = PACKED_SCENE.instantiate()
	return reflect_shield


func play(from: Vector3, to: Vector3) -> void:
	visible = true
	global_position = from
	var prev_rotation: Vector3 = rotation
	look_at(to)
	rotation.x = prev_rotation.x
	rotation.z = prev_rotation.z
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_interval(DURATION)
	_tween.tween_callback(queue_free)
	_tween.play()
