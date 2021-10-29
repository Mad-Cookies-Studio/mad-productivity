extends HBoxContainer

signal update_values

var color_int : int = 0
var color_node : ColorRect

func _ready() -> void:
	pass # Replace with function body.
	
	
func update_values() -> void:
	emit_signal("update_values")
	
	

func _on_ColorPicker_color_changed(color: Color) -> void:
	Defaults.ui_theme.set_color(color_int, color)
	color_node.color = color


func _on_Option_setting_color(which : int, node : ColorRect) -> void:
	color_int = which
	color_node = node


func _on_Option_value_changed(value: float) -> void:
	Defaults.ui_theme.contrast = value
	Defaults.update_theme()
