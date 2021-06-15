extends HBoxContainer

signal delete_pressed(idx)

var id : int

func show_up() -> void:
	$Delete.hide()
	$Tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.0)
	$Tween.start()


func _on_TrackedItem_mouse_entered() -> void:
	$Delete.show()


func _on_TrackedItem_mouse_exited() -> void:
	$Delete.hide()


func _on_Delete_button_up() -> void:
	emit_signal("delete_pressed", id)
	queue_free()
