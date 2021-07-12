extends Panel

signal view_changed(which)

var buttons : Array


var active_btn : TextureButton


func _ready() -> void:
	get_viewport().connect("size_changed", self, "on_window_size_changed")
	var idx : int = 0
	
	for i in $Buttons.get_children():
		buttons.append(i)
		i.connect("toggled_menu_btn", self, "on_toggled_menu_btn", [i, idx])
		idx += 1


func mouse_entered_menu_btn() -> void:
	pass


func manual_view_toggle(which : int) -> void:
	$Buttons.get_child(which).pressed = true


# which passes the specific node
# idx send the id of the child. Can be used for toggling Views
func on_toggled_menu_btn(which : TextureButton, idx : int) -> void:
	if idx == 6:
		print("going to a random view")
		var rand : = randi() % $Buttons.get_child_count()
		if rand == get_parent().get_parent().active_view:
			rand += 1
		$Buttons.get_child(rand).pressed = true
		return
	if which != active_btn and active_btn != null:
		active_btn.deactivate()
	
	emit_signal("view_changed", idx)
	active_btn = which
	move_selection_box(which.rect_position.y)


func on_window_size_changed() -> void:
	yield(get_tree(), "idle_frame")
	if active_btn:
		move_selection_box(active_btn.rect_position.y)


func move_selection_box(where : float) -> void:
	$Tween.interpolate_property($SelectionBox, "rect_position:y", $SelectionBox.rect_position.y, where, 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.0)
	$Tween.interpolate_property($SelectionBox/Particles, "speed_scale", 1.75, 0.2, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0.0)
	$Tween.start()
