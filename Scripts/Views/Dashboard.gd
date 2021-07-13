extends Control

export var title : String
var midnight_check : Dictionary


func _ready() -> void:
	midnight_check = OS.get_time()
	update_time()
	update_date()


func entering_view() -> void:
	Defaults.emit_signal("view_changed", title, false, false)
	$VBoxContainer/Date.visible = Defaults.settings_res.show_date
	
	
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


func _on_Timer_timeout() -> void:
	update_time()


func _on_Discord_pressed() -> void:
	OS.shell_open("https://discord.gg/bWxcZjn")
