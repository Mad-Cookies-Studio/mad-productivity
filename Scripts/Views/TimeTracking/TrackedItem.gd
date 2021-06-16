extends ColorRect

signal delete_pressed(idx)
signal time_track_item(_name)

var id : int

func fill_details(date : String, time : String, _name : String) -> void:
	$H/Date.text = date
	$H/TrackedTime.text = time
	$H/ProjectName.text = _name
	


func show_up() -> void:
	$H/Delete.hide()
	$H/TimeTrack.hide()
	$Tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.0)
	$Tween.start()


func _on_TrackedItem_mouse_entered() -> void:
	color = Color(0.086274, 0.152941, 0.160784)
	if Defaults.time_tracking:
		$H/TimeTrack.modulate.a = 0.5
	else:
		$H/TimeTrack.modulate.a = 1.0
		
	$H/TimeTrack.show()
	$H/Delete.show()


func _on_TrackedItem_mouse_exited() -> void:
	color = Color(0.07451, 0.133333, 0.141176)
	$H/TimeTrack.hide()
	$H/Delete.hide()


func _on_Delete_button_up() -> void:
	emit_signal("delete_pressed", id)
	queue_free()


func _on_TimeTrack_button_up() -> void:
	emit_signal("time_track_item", $H/ProjectName.text)
