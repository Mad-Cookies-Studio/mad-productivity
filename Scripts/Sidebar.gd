extends Panel

var buttons : Array


var active_btn : TextureButton


func _ready() -> void:
	for i in $Buttons.get_children():
		buttons.append(i)
		i.connect("toggled_menu_btn", self, "on_toggled_menu_btn", [i])
	
	OS.window_position = (OS.get_screen_size() / 2) - (OS.window_size / 2)
	buttons[0].btn_toggled(true)


func mouse_entered_menu_btn() -> void:
	pass


func on_toggled_menu_btn(which : TextureButton) -> void:
	if which != active_btn and active_btn != null:
		active_btn.deactivate()
	
	active_btn = which
	move_selection_box(which.rect_position.y)


func move_selection_box(where : float) -> void:
	$Tween.interpolate_property($SelectionBox, "rect_position:y", $SelectionBox.rect_position.y, where, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT, 0.0)
	$Tween.start()
