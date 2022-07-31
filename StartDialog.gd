extends Control

func _ready() -> void:
	if OS.get_name() == "X11" or OS.get_name() == "Server":
		OS.set_borderless_window(false)
	else:
		OS.set_borderless_window(true)
	get_tree().change_scene("res://Main.tscn")
