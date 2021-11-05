extends ColorPicker

signal show_colour_panel(really)

func _ready() -> void:
	get_parent().show()
	get_parent().rect_size.x = 0.0


func _on_Option_setting_color(which, node) -> void:
	color = node.color
	emit_signal("show_colour_panel", true)


func _on_Button_pressed() -> void:
	emit_signal("show_colour_panel", false)
