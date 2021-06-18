extends Label

export(Resource) var resource

func _ready() -> void:
	modulate.a = 0.0
	text = "\"" + resource.messages[randi() % resource.messages.size()] +  "\""
	$Tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 5.0, Tween.TRANS_CUBIC, Tween.EASE_OUT, 0.0)
	$Tween.interpolate_property(self, "percent_visible", 0.0, 1.0, 6.0, Tween.TRANS_CUBIC, Tween.EASE_OUT, 0.0)
	$Tween.start()
