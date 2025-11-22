@tool
extends Control

signal found_todo(s_path: String, s_number: int, s_line: String)
signal scanned_file()

const TODO_IGNORE_PATH: String = "res://TODOignore.txt"
const file_section_scene: PackedScene = preload("res://addons/todo_finder/todo_scroll_file_section.tscn")

const EditorToDoScrollFileSection = preload("uid://slunvj24oyy3")

# TODO: Fold all/unfold all

@onready
var scanned_label: Label = %ScannedCountLabel
@onready
var scan_button: Button = %ScanButton
@onready
var scroll_parent: VBoxContainer = %ScrollParent

@onready var scan_todo_finder_check_box: CheckBox = %ScanTodoFinderCheckBox
@onready var scan_addons_check_box: CheckBox = %ScanAddonsCheckBox


var todo_regex: RegEx
var ignores: Array[RegEx] = []
var scanned_count: int = 0
var sections: Dictionary[String, EditorToDoScrollFileSection] = {}

func _ready() -> void:
	scan_button.pressed.connect(_scan)
	scanned_label.visible = false
	sections.clear()
	self.found_todo.connect(_found_todo)
	self.scanned_file.connect(_scanned_file_finished)
	var scroll_children := scroll_parent.get_children()
	for c in scroll_children:
		scroll_parent.remove_child(c)
		c.queue_free()
	todo_regex = RegEx.new()
	todo_regex.compile("#+\\s*TODO")

func _exit_tree() -> void:
	scan_button.pressed.disconnect(_scan)
	self.found_todo.disconnect(_found_todo)
	self.scanned_file.disconnect(_scanned_file_finished)

func _scan() -> void:
	sections.clear()
	scanned_count = 0
	var scroll_children := scroll_parent.get_children()
	for c in scroll_children:
		scroll_parent.remove_child(c)
		c.queue_free()
	_get_ignores()
	_scan_dirs("res://")
	
	

func _scan_dirs(p_dir: String) ->  void:
	var dirs := DirAccess.get_directories_at(p_dir)
	for d in dirs:
		var path: String = "%s%s/" % [p_dir, d]
		var ignore: bool = false
		for regex in ignores:
			if regex.search(path):
				ignore = true
				break

		if ignore:
			continue
		
		if "res://addons/todo_finder" in path:
			if scan_todo_finder_check_box.button_pressed:
				_scan_dirs(path)
			continue
		
		# General addon check (skip other addons if unchecked)
		if not scan_addons_check_box.button_pressed:
			if "res://addons" in path and path != "res://addons/":
				continue

		_scan_dirs(path)
	
	var files := DirAccess.get_files_at(p_dir)
	for f in files:
		if not f.ends_with(".gd"):
			continue
		var path: String = "%s%s" % [p_dir, f]
		var ignore: bool = false
		for regex in ignores:
			if regex.search(path):
				ignore = true
				break
		if ignore:
			continue
		_scan_file(path)
		

func _scan_file(p_file_path: String) -> void:
	var file = FileAccess.open(p_file_path, FileAccess.READ)
	var lines: PackedStringArray = file.get_as_text().split("\n")
	var line_number: int = 1
	for line in lines:
		if todo_regex.search(line):
			if line != "	todo_regex.compile(\"#+\\s*TODO\")":
				found_todo.emit(p_file_path, line_number, line.strip_edges())
		line_number += 1
		
	scanned_file.emit()

func _found_todo(p_file_path: String, p_line_number: int, p_line: String) -> void:
	if not p_file_path in sections:
		var section: EditorToDoScrollFileSection = file_section_scene.instantiate()
		scroll_parent.add_child(section)
		section.set_file_name(p_file_path)
		sections[p_file_path] = section
	sections[p_file_path].add_todo(p_file_path, p_line_number, p_line)

func _scanned_file_finished() -> void:
	scanned_count += 1
	scanned_label.visible = true
	scanned_label.text = "Scanned %d files..." % scanned_count 


func _get_ignores() -> void:
	if not FileAccess.file_exists(TODO_IGNORE_PATH):
		return
	var file = FileAccess.open(TODO_IGNORE_PATH, FileAccess.READ)
	var lines: PackedStringArray = file.get_as_text().split("\n")
	ignores.clear()
	for line in lines:
		var pattern: String = line.strip_edges()
		if pattern.is_empty():
			continue
		var regex := RegEx.new()
		regex.compile(line.strip_edges())
		ignores.append(regex)
	file.close()
