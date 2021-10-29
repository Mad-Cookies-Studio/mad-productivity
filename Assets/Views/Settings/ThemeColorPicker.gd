extends ColorPicker



func _ready() -> void:
	get_parent().hide()


func _on_Option_setting_color(which, node) -> void:
	color = node.color
	get_parent().show()


func _on_Button_pressed() -> void:
	get_parent().hide()
