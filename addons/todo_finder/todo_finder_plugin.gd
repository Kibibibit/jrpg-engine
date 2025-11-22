@tool
extends EditorPlugin

const TODOPanel: PackedScene = preload("res://addons/todo_finder/todo_finder_panel.tscn")

var panel_instance: Control

func _enter_tree():
	panel_instance = TODOPanel.instantiate()
	EditorInterface.get_editor_main_screen().add_child(panel_instance)
	_make_visible(false)


func _exit_tree():
	if panel_instance:
		panel_instance.queue_free()


func _has_main_screen():
	return true


func _make_visible(visible):
	if panel_instance:
		panel_instance.visible = visible


func _get_plugin_name():
	return "TODO"


func _get_plugin_icon():
	return EditorInterface.get_editor_theme().get_icon("AnimationTrackList", "EditorIcons")
