extends Label


func _wobble(duration : float = 1.0, amount : float = 1.3) -> void:
	$Tween.interpolate_property(self, "rect_scale", Vector2.ONE * amount, Vector2.ONE, duration, Tween.TRANS_ELASTIC, Tween.EASE_OUT, 0.0)
	$Tween.start()
