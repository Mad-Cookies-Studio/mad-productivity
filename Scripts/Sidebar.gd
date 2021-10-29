extends Panel

signal view_changed(which, target)

var buttons : Array


var active_btn : TextureButton

var previous_random_view : int = -1
var previous_view : int

func _ready() -> void:
	update_theme()
	get_viewport().connect("size_changed", self, "on_window_size_changed")
	var idx : int = 0
	
	for i in $Buttons.get_children():
		buttons.append(i)
		i.connect("toggled_menu_btn", self, "on_toggled_menu_btn", [i, idx, i.target])
		idx += 1

	for i in $BotButtons.get_children():
		buttons.append(i)
		i.connect("toggled_menu_btn", self, "on_toggled_menu_btn", [i, idx, i.target])
		idx += 1


# IMPORTANT: Last button of the buttons must be the randomiser.
func manual_view_toggle(which : int = 0) -> void:
	which = clamp(which, 0, $Buttons.get_child_count() + $BotButtons.get_child_count() - 1)
	# IMPORTANT: If the randomiser changes in any way
	# This part needs a little rework. AKA, remove the -1
	if which < $Buttons.get_child_count():
		$Buttons.get_child(which).pressed = true
	else:
		$BotButtons.get_child(which - $Buttons.get_child_count()).pressed = true
		


# which passes the specific node
# idx send the id of the child. Can be used for toggling Views
func on_toggled_menu_btn(which : TextureButton, idx : int, target : String = "") -> void:
	if target == "Random":
		print("going to a random view")
		
		var rand : int = get_random_view_number()
		while rand == previous_random_view:
			rand = get_random_view_number()
			
#		if rand == get_parent().get_parent().active_view:
#			rand += 1
#		$Buttons.get_child(rand).pressed = true
		manual_view_toggle(rand)
		previous_random_view = rand
		return
	if which != active_btn and active_btn != null:
		active_btn.deactivate()
	
	emit_signal("view_changed", idx, target)
	active_btn = which
	if active_btn.bottom:
		move_selection_box(which.rect_position.y + which.get_parent().rect_position.y)
	else:
		move_selection_box(which.rect_position.y)


func get_random_view_number() -> int:
	return randi() % $Buttons.get_child_count() + $BotButtons.get_child_count()


func on_window_size_changed() -> void:
	yield(get_tree(), "idle_frame")
	if active_btn:
#		move_selection_box(active_btn.rect_position.y)
		move_selection_box(active_btn.rect_global_position.y)


func move_selection_box(where : float = 0.0, add_parent_y : bool = false) -> void:
	$Tween.interpolate_property($SelectionBox, "rect_position:y", $SelectionBox.rect_position.y, where, 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.0)
	$Tween.interpolate_property($SelectionBox/Particles, "speed_scale", 1.75, 0.2, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0.0)
	$Tween.start()


func update_theme() -> void:
	$SelectionBox.color = Defaults.ui_theme.highlight_colour
	$SelectionBox/Particles.modulate = Defaults.ui_theme.highlight_colour
	if active_btn:
		active_btn.modulate = Defaults.btn_active_colour
