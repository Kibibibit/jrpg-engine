@tool
extends VBoxContainer

const line_scene: PackedScene = preload("res://addons/todo_finder/todo_scroll_line.tscn")
const EditorToDoScrollLine = preload("uid://nhs2rxv1hvye")

@onready
var foldable_container: FoldableContainer = %FoldableContainer
@onready
var link_button: LinkButton = %LinkButton

@onready
var line_parent: VBoxContainer = %LineParent

var path: String
var lowest_line: int = -1

func set_file_name(p_file: String) -> void:
	foldable_container.title = p_file
	link_button.text = p_file
	path = p_file
	if link_button.pressed.is_connected(_on_link_pressed):
		link_button.pressed.disconnect(_on_link_pressed)
	link_button.pressed.connect(_on_link_pressed)

func add_todo(p_file: String, p_line_number: int, p_line: String) -> void:
	var line: EditorToDoScrollLine = line_scene.instantiate()
	if lowest_line == -1 or p_line_number < lowest_line:
		lowest_line = p_line_number
	line_parent.add_child(line)
	foldable_container.title = "%s: %d TODOs" % [path, line_parent.get_child_count()]
	line.set_todo(p_file, p_line_number, p_line)

func _on_link_pressed() -> void:
	EditorInterface.edit_script(load(path), lowest_line)
	EditorInterface.set_main_screen_editor("Script")
