extends Node


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("view_down"):
		get_parent().manual_view_toggle(get_parent().active_view + 1)
	if event.is_action_pressed("view_up"):
		get_parent().manual_view_toggle(get_parent().active_view - 1)
	if event.is_action_pressed("use"):
		print("pressed use")
