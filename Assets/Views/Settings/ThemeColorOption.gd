extends ColorRect

signal setting_color(which, node)

export(int, "primary_col", "highlight_colour", "text_color") var set_name

var value : Color 


func _ready() -> void:
	value = Defaults.ui_theme.get_color(set_name)
	color = value
	connect("gui_input", self, "on_gui_input")



func on_gui_input(event : InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		emit_signal("setting_color", set_name, self)
