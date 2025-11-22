extends Node


func wait(time: float) -> void:
	await get_tree().create_timer(time).timeout
