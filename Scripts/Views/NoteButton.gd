extends Button

signal note_delete_pressed(btn, res)
signal start_time_track(_name)

var res : NoteResource
var deleting = false

export(Color) var delete_btn_colour
var target_opacity : float

func _ready() -> void:
#	$DeleteBtn.modulate = delete_btn_colour
#	$DeleteBtn.modulate.a = 1.0
	target_opacity = $DeleteBtn.modulate.a
	$DeleteBtn.hide()
	$TimeTrack.hide()
	$DeleteBtn.connect("button_up", self, "_on_delete_btn_pressed")
	$TimeTrack.connect("button_up", self, "_on_time_track_btn_pressed")
	connect("mouse_entered", self, "mouse_entered")
	connect("mouse_exited", self, "mouse_exited")
	
	
func hide_delete(duration : float = 0.5) -> void:
	# IMPORTANT : tween.remove_all() is the way to reset and stop all animation so that they cant overlap
	$Tween.remove_all()
	$Tween.interpolate_property($DeleteBtn, 'rect_scale', Vector2.ONE ,Vector2.ONE * 0.01, duration, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.0)
	$Tween.interpolate_property($DeleteBtn, 'modulate:a', modulate.a ,0.0, duration, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.0)
	$Tween.start()
	
func show_delete(duration : float = 0.5) -> void:
	$Tween.remove_all()
	$Tween.interpolate_property($DeleteBtn, 'rect_scale', Vector2.ONE * 0.01 ,Vector2.ONE, duration, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.0)
	$Tween.interpolate_property($DeleteBtn, 'modulate:a', modulate.a ,target_opacity, duration, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.0)
	$Tween.start()
	
	
func mouse_entered() -> void:
#	show_delete()
	$DeleteBtn.show()
	$TimeTrack.show()
	
func mouse_exited() -> void:
#	hide_delete()
	$DeleteBtn.hide()
	$TimeTrack.hide()
	
	
func _on_delete_btn_pressed() -> void:
	emit_signal("note_delete_pressed", self, res)
	delete_note(self, res)
		
		
func _on_time_track_btn_pressed() -> void:
	Defaults.emit_signal("track_item", res.title)
		
		
func delete_note(btn : Button, _res : NoteResource) -> void:
	deleting = true
	var dir : Directory = Directory.new()
	var err = dir.remove(Defaults.NOTES_SAVE_PATH + _res.save_name + ".tres")
	queue_free()
	
