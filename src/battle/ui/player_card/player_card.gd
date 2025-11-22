extends Control
class_name PlayerCard

## TODO: Full refactor for styling

const PLAYER_CARD: PackedScene = preload("uid://br151y17x7s4h")

@onready var name_label: Label = %NameLabel
@onready var hp_progress_bar: ProgressBar = %HpProgressBar
@onready var hp_label: Label = %HpLabel
@onready var mp_progress_bar: ProgressBar = %MpProgressBar
@onready var mp_label: Label = %MpLabel
@onready var ailments_label: Label = %AilmentsLabel

var _hp_tween: Tween
var _mp_tween: Tween

var character: CharacterState

static func create_new(p_character: CharacterState) -> PlayerCard:
	var instance: PlayerCard = PLAYER_CARD.instantiate() as PlayerCard
	instance.character = p_character
	return instance

func _ready() -> void:
	name_label.text = character.get_display_name()
	hp_progress_bar.value = _get_hp_percentage()
	mp_progress_bar.value = _get_mp_percentage()
	hp_label.text = _get_hp_text()
	mp_label.text = _get_mp_text()
	character.hp_updated.connect(_on_hp_updated)
	character.mp_updated.connect(_on_mp_updated)

func _get_hp_percentage() -> float:
	return float(character.get_current_hp()) / float(character.get_max_hp())

func _get_mp_percentage() -> float:
	return float(character.get_current_mp()) / float(character.get_max_mp())

func _get_hp_text() -> String:
	return "%d/%d" % [character.get_current_hp(), character.get_max_hp()]

func _get_mp_text() -> String:
	return "%d/%d" % [character.get_current_mp(), character.get_max_mp()]

func _on_hp_updated() -> void:
	hp_label.text = _get_hp_text()
	if _hp_tween:
		_hp_tween.kill()
	_hp_tween = create_tween()
	## TODO: Make value constant
	_hp_tween.tween_property(hp_progress_bar, "value", _get_hp_percentage(), 0.1)
	_hp_tween.play()

func _on_mp_updated() -> void:
	mp_label.text = _get_mp_text()
	if _mp_tween:
		_mp_tween.kill()
	_mp_tween = create_tween()
	## TODO: Make value constant
	_mp_tween.tween_property(mp_progress_bar, "value", _get_mp_percentage(), 0.1)
	_mp_tween.play()
