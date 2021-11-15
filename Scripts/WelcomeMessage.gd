extends Label

export(Resource) var resource

var texts : Array
var quote_index : int
func _ready() -> void:
	texts = Defaults.settings_res.quote_list.values()
	load_new_text(get_random_index())

func load_new_text(index: int) -> void:
	modulate.a = 0.0
	quote_index += index
	show_new_text(texts[quote_index % texts.size()])

func _on_Next_pressed() -> void:
	load_new_text(1)
func _on_Previous_pressed() -> void:
	load_new_text(-1)

func show_new_text(quote_text) -> void:
	text = "\"" + quote_text +  "\""
	$Tween.remove_all()
	$Tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 3.0, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.0)
	$Tween.interpolate_property(self, "percent_visible", 0.0, 1.0, 2.0, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.0)
	$Tween.start()

func get_random_index() -> int:
	return randi()%texts.size()
