extends Control
class_name TargetReticle

const PACKED_SCENE = preload("uid://bx0pih568vhii")

var target: Vector3 = Vector3.ZERO
var targeting: bool = false

static func create_new() -> TargetReticle:
	var reticle: TargetReticle = PACKED_SCENE.instantiate()
	return reticle


func _process(delta: float) -> void:
	if not targeting:
		visible = false
		return
	visible = true

	var target_position: Vector2 = get_target_position_2d()

	global_position = global_position.move_toward(target_position, 1000 * delta)

func set_target(p_target: Vector3) -> void:
	target = p_target
	if not targeting:
		global_position = get_target_position_2d()
	targeting = true

func unset_target() -> void:
	targeting = false



func get_target_position_2d() -> Vector2:
	return get_viewport().get_camera_3d().unproject_position(target)
