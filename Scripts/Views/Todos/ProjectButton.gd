extends Button

signal selected_project(_name, index, child_index)
signal delete_project(id)

var id : int
var finished : bool = false

func _ready() -> void:
	connect("mouse_entered", self, "on_mouse_entered")
	connect("mouse_exited", self, "on_mouse_exited")
	$Tween.connect("tween_all_completed", self, "on_tween_done")
	on_mouse_exited()
	update_theme()
	
	
func update_theme() -> void:
#	$CompleteBG/CompleteBar.color = Defaults.ui_theme.highlight_colour
	pass
	
	
func on_mouse_entered() -> void:
	$TimeTrack.show()
	$DeleteBtn.show()
	
	
func on_mouse_exited() -> void:
	$TimeTrack.hide()
	$DeleteBtn.hide()
	

func _on_ProjectButton_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1:
		emit_signal("selected_project", text, id, get_index())


func _on_DeleteBtn_pressed() -> void:
	emit_signal("delete_project", id)
	queue_free()

func set_percent_done(perc : float = 0.0) -> void:
	finished = bool(floor(perc))
	$Tween.remove_all()
	$Tween.interpolate_property($CompleteBG/CompleteBar, "rect_scale:x", $CompleteBG/CompleteBar.rect_scale.x, perc, 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.0)
	$Tween.interpolate_property($CompleteBG/CompleteBar, "modulate:a", $CompleteBG/CompleteBar.modulate.a, perc, 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.0)
	$Tween.start()
#	$CompleteBG/CompleteBar.rect_scale.x = clamp(perc, 0.0, 1.0)


func on_tween_done() -> void:
	if finished:
#		$CompleteSound.play()
		pass


func _on_TimeTrack_pressed() -> void:
	Defaults.emit_signal("track_item", text)
