extends Control

export var title : String
var midnight_check : Dictionary


func _ready() -> void:
	midnight_check = OS.get_time()
	update_time()
	update_date()


func entering_view() -> void:
	Defaults.active_view_pointer = self
	Defaults.emit_signal("view_changed", title, false, false)
	$VBoxContainer/Date.visible = Defaults.settings_res.show_date
	update_view_text()
	
	
func leaving_view() -> void:
	pass


func update_time() -> void:
	if Defaults.settings_res.show_secs_dash:
		$VBoxContainer/Time.text = Defaults.get_time_with_semicoloumns({})
	else:
		$VBoxContainer/Time.text = Defaults.get_time_with_semicoloumns_no_secs({})
		
	#Update the date if we've gone over midnight
	if OS.get_time().hour < midnight_check.hour:
		update_date()
	
	
func update_date() -> void:
	$VBoxContainer/Date.text = Defaults.get_full_date_as_string({})


func update_theme() -> void:
	$VBoxContainer/Date.add_color_override("font_color", Defaults.ui_theme.text_color)
	$VBoxContainer/Time.add_color_override("font_color", Defaults.ui_theme.text_color)
	$VBoxContainer/Panel/WelcomeMessage.add_color_override("font_color", Defaults.ui_theme.text_color.inverted())
	$VBoxContainer/Panel/Next.modulate = Defaults.ui_theme.highlight_colour
	$VBoxContainer/Panel/Next2.modulate = Defaults.ui_theme.highlight_colour


func update_view_text() -> void:
	var text : String = ""
	Defaults.emit_signal("update_view_info", text)


## SIGNALS

func _on_Timer_timeout() -> void:
	update_time()


func _on_Discord_pressed() -> void:
	OS.shell_open("https://discord.gg/bWxcZjn")
