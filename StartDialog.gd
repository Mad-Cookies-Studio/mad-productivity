extends Control

func _ready() -> void:
	if OS.get_name() == "X11" or OS.get_name() == "Server":
		ProjectSettings.set_setting("display/window/size/borderless", false)
		get_tree().change_scene("res://Main.tscn")
	else:
		ProjectSettings.set_setting("display/window/size/borderless", true)
		get_tree().change_scene("res://Main.tscn")
