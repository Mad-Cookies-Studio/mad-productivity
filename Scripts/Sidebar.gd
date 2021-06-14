extends Panel

signal view_changed(which)

var buttons : Array


var active_btn : TextureButton


func _ready() -> void:
	var idx : int = 0
	for i in $Buttons.get_children():
		buttons.append(i)
		i.connect("toggled_menu_btn", self, "on_toggled_menu_btn", [i, idx])
		idx += 1
	
	OS.window_position = (OS.get_screen_size() / 2) - (OS.window_size / 2)
	buttons[0].btn_toggled(true)


func mouse_entered_menu_btn() -> void:
	pass


# which passes the specific node
# idx send the id of the child. Can be used for toggling Views
func on_toggled_menu_btn(which : TextureButton, idx : int) -> void:
	if which != active_btn and active_btn != null:
		active_btn.deactivate()
	
	emit_signal("view_changed", idx)
	active_btn = which
	move_selection_box(which.rect_position.y)


func move_selection_box(where : float) -> void:
	$Tween.interpolate_property($SelectionBox, "rect_position:y", $SelectionBox.rect_position.y, where, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT, 0.0)
	$Tween.interpolate_property($SelectionBox/Particles, "speed_scale", 1.75, 0.2, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0.0)
	$Tween.start()
