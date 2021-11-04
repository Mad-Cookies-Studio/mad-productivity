extends Panel

signal task_set_done(really, idx)
signal task_text_changed(_text, _idx)
signal task_delete(_idx)
signal task_time_track(text)

var idx : int
var done : bool

func _ready() -> void:
	$TimeTrack.hide()
	$DeleteBtn.hide()


func update_theme() -> void:
	pass


func update_self(_text : String, _done : bool, _date : Dictionary, _idx : int) -> void:
	$HBoxContainer/CheckBox.pressed = _done
	$HBoxContainer/Task.text = _text
	$HBoxContainer/Date.text = Defaults.get_date_with_time_string(_date)


func _on_Task_text_changed(new_text: String) -> void:
	emit_signal("task_text_changed", new_text, idx)


func _on_TODOitem_mouse_entered() -> void:
	# TODO: Update color in an appropriate way
	#color = Color(0.576471, 0.627451, 0.631373, 0.129412)
	$TimeTrack.show()
	$DeleteBtn.show()


func _on_TODOitem_mouse_exited() -> void:
	#color = Color(0.086274, 0.152941, 0.160784)
	$TimeTrack.hide()
	$DeleteBtn.hide()


func _on_DeleteBtn_button_up() -> void:
	emit_signal("task_delete", idx)
	queue_free()


func _on_TimeTrack_button_up() -> void:
	emit_signal("task_time_track", $HBoxContainer/Task.text)


func _on_CheckBox_set_done(really) -> void:
	emit_signal("task_set_done", really, idx)
	done = really
