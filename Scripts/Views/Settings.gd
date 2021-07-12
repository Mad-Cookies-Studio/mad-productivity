extends Control

export var title : String

var res : SettingsResource

# UI state machine functions
func entering_view() -> void:
	Defaults.emit_signal("view_changed", title, false, false)
	set_up_btns()
	
	
func leaving_view() -> void:
	Defaults.save_settings_resource()
	
	
func save() -> void:
	Defaults.save_settings_resource()


func _ready() -> void:
	res = Defaults.settings_res
	update_settings()


func set_up_btns() -> void:
	$C/VBoxContainer/FontSize/Option.select(res.font_size)
	$C/VBoxContainer/SecsDashboard/Option.pressed = res.show_secs_dash
	$C/VBoxContainer/WindowPos/Option.pressed = res.remember_window_settings
	$C/VBoxContainer/LongPause/Option.value = res.pomo_long_pause_length
	$C/VBoxContainer/LongPauseFreq/Option.value = res.pomo_long_pause_freq
	$C/VBoxContainer/ShortPause/Option.value = res.pomo_short_pause_length
	$C/VBoxContainer/WorkTimeLength/Option.value = res.pomo_work_time_length
	$C/VBoxContainer/WindowPos2/Option.pressed = res.remember_last_session_view


func update_settings() -> void:
	Defaults.change_body_font_size(res.font_size)


# -- > SIGNALS <-- #
func _on_Option_item_selected(index: int) -> void:
	res.font_size = index
	Defaults.change_body_font_size(index)


func _on_secsDashboard_toggled(button_pressed: bool) -> void:
	res.show_secs_dash = button_pressed


func _on_windowPos_toggled(button_pressed: bool) -> void:
	res.remember_window_settings = button_pressed


func _on_workTimeLength_value_changed(value: float) -> void:
	res.pomo_work_time_length = int(value)


func _on_ShortPauseLength_value_changed(value: float) -> void:
	res.pomo_short_pause_length = int(value)


func _on_LongPauseLength_value_changed(value: float) -> void:
	res.pomo_long_pause_length = int(value)


func _on_LongPauseFreq_value_changed(value: float) -> void:
	res.pomo_long_pause_freq = int(value)


func _on_lastSessionView_toggled(button_pressed: bool) -> void:
	res.remember_last_session_view = button_pressed
	res.last_session_view = 0
	
	if !button_pressed:
		res.last_session_view = -1
