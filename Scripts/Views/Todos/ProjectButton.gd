extends Button

signal selected_project(_name, index, child_index)

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
