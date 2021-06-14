extends Node

export(Color) var btn_active_colour : Color
export(Color) var btn_inactive_colour : Color


func quit() -> void:
	get_tree().quit()
