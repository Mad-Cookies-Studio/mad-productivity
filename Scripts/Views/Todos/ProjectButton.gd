extends Button

signal selected_project(_name, index, child_index)
signal delete_project(id)

var id : int


func _ready() -> void:
	connect("mouse_entered", self, "on_mouse_entered")
	connect("mouse_exited", self, "on_mouse_exited")
	on_mouse_exited()
	
	
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
	$CompleteBG/CompleteBar.rect_scale.x = clamp(perc, 0.0, 1.0)
