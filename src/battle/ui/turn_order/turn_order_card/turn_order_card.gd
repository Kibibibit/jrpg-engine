extends Control
class_name TurnOrderCard

const PACKED_SCENE := preload("uid://ba155pyn2mcpr")

const WIDTH := 70
const HEIGHT := 70
const SPEED := 0.1

@onready var label: Label = %Label

var index: int = 0
var character: CharacterState

var target_position: Vector2 = Vector2.ZERO

var _tween: Tween

static func create_new(p_index: int, p_character: CharacterState) -> TurnOrderCard:
	var instance: TurnOrderCard = PACKED_SCENE.instantiate()
	instance.character = p_character
	instance.position.y = -HEIGHT
	instance.position.x = p_index * WIDTH
	instance.index = p_index
	return instance
	
func _ready() -> void:
	label.text = character.get_display_name()

func _reset_tween() -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()

func _get_target_position() -> Vector2:
	return Vector2(
		index * WIDTH,
		0 if index > 0 else 10
	)

func animate() -> void:
	_reset_tween()
	_tween.tween_property(self, "position", _get_target_position(), SPEED)
	_tween.play()

func remove() -> void:
	_reset_tween()
	_tween.tween_property(self, "position", Vector2(position.x, -HEIGHT), SPEED)
	_tween.tween_callback(queue_free)
	_tween.play()
