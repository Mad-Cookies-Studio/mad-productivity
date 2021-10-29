extends Panel

signal set_done(really)

var pressed : bool setget set_pressed


func set_pressed(new : bool) -> void:
#	color = Defaults.custom_check_box_inactive
	if new:
#		color = Defaults.custom_check_box_active
		$CheckBox2.show()
	else:
		$CheckBox2.hide()
	pressed = new
	emit_signal("set_done", new)


func _on_CheckBox_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		self.pressed = !self.pressed
