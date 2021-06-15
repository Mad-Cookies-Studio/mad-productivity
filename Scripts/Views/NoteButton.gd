extends Button

signal note_delete_pressed(btn, res)

var res : NoteResource
var deleting = false

export(Color) var delete_btn_colour
var target_opacity : float

func _ready() -> void:
	$DeleteBtn.modulate = delete_btn_colour
	target_opacity = $DeleteBtn.modulate.a
	$DeleteBtn.modulate.a = 0.0
	$DeleteBtn.connect("button_up", self, "_on_delete_btn_pressed")
	connect("mouse_entered", self, "mouse_entered")
	connect("mouse_exited", self, "mouse_exited")
	
	
func hide_delete(duration : float = 0.25) -> void:
	# TODO FIX FAST MOUSE OVER BUG
	$Tween.remove_all()
	$Tween.interpolate_property($DeleteBtn, 'rect_scale', Vector2.ONE ,Vector2.ONE * 0.01, duration, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.0)
	$Tween.interpolate_property($DeleteBtn, 'modulate:a', modulate.a ,0.0, duration, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.0)
	$Tween.start()
	
func show_delete(duration : float = 0.5) -> void:
	# TODO FIX FAST MOUSE OVER BUG
	$Tween.remove_all()
	$Tween.interpolate_property($DeleteBtn, 'rect_scale', Vector2.ONE * 0.01 ,Vector2.ONE, duration, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.0)
	$Tween.interpolate_property($DeleteBtn, 'modulate:a', modulate.a ,target_opacity, duration, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.0)
	$Tween.start()
	
	
func mouse_entered() -> void:
	show_delete()
	
	
func mouse_exited() -> void:
	hide_delete()
	
	
func _on_delete_btn_pressed() -> void:
	pass


func _on_DefaultButton_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if get_local_mouse_position().x > 196:
			emit_signal("note_delete_pressed", self, res)
			delete_note(self, res)
		
		
func delete_note(btn : Button, _res : NoteResource) -> void:
	deleting = true
	var dir : Directory = Directory.new()
	queue_free()
	var err = dir.remove(Defaults.NOTES_SAVE_PATH + _res.save_name + ".tres")
