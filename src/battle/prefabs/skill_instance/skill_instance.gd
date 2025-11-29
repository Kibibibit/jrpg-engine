extends Node3D
class_name SkillInstance

signal on_finished(instance: SkillInstance)

@export var animation_player: AnimationPlayer

var target_position: Vector3 = Vector3.ZERO
var from_position: Vector3 = Vector3.ZERO
var targets: Array[CharacterState] = []
var results: Array[SkillResult] = []
var skill_context: SkillContext

var reached_early_finish: bool = false
var reached_hit_frame: bool = false

func _ready() -> void:
	global_position = target_position
	animation_player.animation_finished.connect(_on_animation_finished)
	if !from_position.is_equal_approx(target_position):
		look_at(from_position)

func play() -> void:
	animation_player.play(&"cast")



func _hit_frame_reached() -> void:
	if reached_hit_frame:
		push_warning("Multiple hit frames registed in this skill instance")
	reached_hit_frame = true
	for result in results:
		@warning_ignore("redundant_await")
		await result.apply(skill_context)

func _early_finish_reached() -> void:
	if reached_early_finish:
		push_warning("Hit early finish multiple times")
	if not reached_hit_frame:
		push_warning("Early finish triggered before hit frame")
		_hit_frame_reached()
	
	on_finished.emit(self)
	
func _on_animation_finished(_anim_name: String) -> void:
	if not reached_hit_frame:
		await _hit_frame_reached()
	
	if not reached_early_finish:
		on_finished.emit(self)
	queue_free()
	
