extends ColorRect

signal new_tracked_item_text(new_text, id)
signal delete_pressed(idx)
signal time_track_item(_name)

var id : int

var highlight_color : Color
var idle_color : Color

func _ready() -> void:
	idle_color = Color(1, 1, 1, 0)
	highlight_color = Defaults.ui_theme.normal
	color = idle_color


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
	color = highlight_color
	if Defaults.time_tracking:
		$H/TimeTrack.modulate.a = 0.5
	else:
		$H/TimeTrack.modulate.a = 1.0
		
	$H/TimeTrack.show()
	$H/Delete.show()


func _on_TrackedItem_mouse_exited() -> void:
	color = idle_color
	$H/TimeTrack.hide()
	$H/Delete.hide()


func _on_Delete_button_up() -> void:
	emit_signal("delete_pressed", id)
	queue_free()


func _on_TimeTrack_button_up() -> void:
	emit_signal("time_track_item", $H/ProjectName.text)


func _on_ProjectName_text_changed(new_text: String) -> void:
	emit_signal("new_tracked_item_text", new_text, id)
