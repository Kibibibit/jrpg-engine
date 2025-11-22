@tool
extends Control

@onready
var line_number_button: LinkButton = %LineNumberButton
@onready
var text_label: Label = %Label

var line_number: int = 0
var path: String

func set_todo(p_file: String, p_line_number: int, p_line: String) -> void:
	text_label.text = p_line
	path = p_file
	line_number = p_line_number
	line_number_button.text = "Line: %d" % p_line_number
	line_number_button.pressed.connect(_on_pressed)

func _on_pressed() -> void:
	EditorInterface.edit_script(load(path), line_number)
	EditorInterface.set_main_screen_editor("Script")
