extends Node

signal shortcut_use
signal shortcut_focus


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("view_down"):
		get_parent().manual_view_toggle(get_parent().active_view + 1)
	if event.is_action_pressed("view_up"):
		get_parent().manual_view_toggle(get_parent().active_view - 1)
	if event.is_action_pressed("shortcut_use"):
		emit_signal("shortcut_use")
	if event.is_action_pressed("shortcut_focus"):
		emit_signal("shortcut_focus")
