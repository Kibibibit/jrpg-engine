extends Control
class_name DamageNumber

## TODO: Style
const NORMAL = preload("uid://daa0gjdmfelx2")
const HEAL = preload("uid://d082fj2iur7up")
const MISS = preload("uid://jdcqbwcclpdi")
const BLOCK = preload("uid://d0fdx12x1ytct")
const CRITICAL = preload("uid://cvotasc63f2ww")
const RESIST = preload("uid://dfanuktxrt0kh")


enum Type {
	NORMAL,
	HEAL,
	MISS,
	BLOCK,
	CRITICAL,
	RESIST,
	WEAK
}

const SCENES: Dictionary[Type, PackedScene] = {
	Type.NORMAL: NORMAL,
	Type.HEAL: HEAL,
	Type.MISS: MISS,
	Type.BLOCK: BLOCK,
	Type.CRITICAL: CRITICAL,
	Type.RESIST: RESIST,
	Type.WEAK: CRITICAL # Crit and Weak share the same style (for now) 
}

const REPLACE_STRINGS_2: Dictionary[Type, String] = {
	Type.CRITICAL: "CRITICAL",
	Type.WEAK: "WEAK"
}

@export var label: Label


static func create_new(amount: int, type: Type) -> DamageNumber:
	assert(SCENES.has(type), "DamageNumber type %s not found in SCENES dictionary" % str(type))
	var scene: PackedScene = SCENES[type]
	var instance: DamageNumber = scene.instantiate() as DamageNumber
	var label_text: String = instance.label.text
	label_text = label_text.replace("${1}", str(amount))
	if REPLACE_STRINGS_2.has(type):
		label_text = label_text.replace("${2}", REPLACE_STRINGS_2[type])
	instance.label.text = label_text
	return instance


	

func _ready() -> void:
	var tween := get_tree().create_tween()
	tween.tween_interval(0.5)
	tween.tween_property(self, "modulate", Color(1.0,1.0,1.0,0), 0.5)
	tween.tween_interval(0.1)
	tween.tween_callback(_cleanup)

func _cleanup() -> void:
	queue_free()
