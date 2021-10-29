extends HBoxContainer


func _ready() -> void:
	$Option.value = Defaults.ui_theme.contrast


func _on_CatTheme_update_values() -> void:
	$Option.value = Defaults.ui_theme.contrast
