extends Control

var res : SettingsResource


# UI state machine functions
func entering_view() -> void:
	pass
	
	
func leaving_view() -> void:
	pass
	
	
func save() -> void:
	Defaults.save_settings_resource(res)


func _ready() -> void:
	res = load(Defaults.SETTINGS_SAVE_PATH + Defaults.SETTINGS_SAVE_NAME) as SettingsResource
	$VBoxContainer/UserName.text = res.name
	$VBoxContainer/UserTitle.text = res.title


func _on_UserName_text_changed(new_text: String) -> void:
	res.name = new_text


func _on_UserTitle_text_changed(new_text: String) -> void:
	res.title = new_text
