extends ColorRect

signal update_message(text, id)
signal update_link(link, id)
signal hovered_over

var idx : int = 0


func _ready() -> void:
	pass


func populate(_comment : String, _link : String, _date : Dictionary, _id) -> void:
	$VBoxContainer/Message.text = _comment
	$VBoxContainer/Link.text = _link
	$VBoxContainer/Date.text = Defaults.get_date_with_time_string(_date)
	idx = _id



func show_highlight(final_size, final_alpha) -> void:
	$Tween.remove_all()
	$Tween.interpolate_property($ColorRect, "rect_size:x", $ColorRect.rect_size.x, final_size, 0.4, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.0)
	$Tween.interpolate_property(self, "color:a", color.a, final_alpha, 0.4, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.0)
	$Tween.start()


func _on_ReminderItem_mouse_entered() -> void:
	emit_signal("hovered_over")
	show_highlight(6, 1)


func _on_ReminderItem_mouse_exited() -> void:
	show_highlight(0, 0)


func _on_Message_text_changed(new_text: String) -> void:
	emit_signal("update_message", new_text, idx)


func _on_Link_text_changed(new_text: String) -> void:
	emit_signal("update_link", new_text, idx)
