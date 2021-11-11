extends Label

export(Resource) var resource

func _ready() -> void:
	load_new_text()
	
	
func load_new_text() -> void:
	modulate.a = 0.0
	var random_texts : Array = Defaults.settings_res.quote_list.values()
	random_texts.shuffle()
	
	text = "\"" + random_texts[0] +  "\""
	$Tween.remove_all()
	$Tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 3.0, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.0)
	$Tween.interpolate_property(self, "percent_visible", 0.0, 1.0, 2.0, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.0)
	$Tween.start()


func _on_Next_pressed() -> void:
	load_new_text()
