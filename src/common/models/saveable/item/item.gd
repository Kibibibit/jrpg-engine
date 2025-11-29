extends Resource
class_name Item

@export var _display_name: String
@export_multiline var _description: String

func get_display_name() -> String:
	return _display_name

func get_description() -> String:
	return _description
