extends Control


export var title : String

var res : SettingsResource

# UI state machine functions
func entering_view() -> void:
	Defaults.active_view_pointer = self
	Defaults.emit_signal("view_changed", title, false, false)
	
	
func leaving_view() -> void:
	pass
	
	
func save() -> void:
	Defaults.save_settings_resource()


func _ready() -> void:
	res = Defaults.settings_res
	$VBoxContainer/UserName.text = res.name
	$VBoxContainer/UserTitle.text = res.title


func _on_UserName_text_changed(new_text: String) -> void:
	res.name = new_text


func _on_UserTitle_text_changed(new_text: String) -> void:
	res.title = new_text
