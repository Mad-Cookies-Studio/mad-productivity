extends Control

export var title : String

var res : SettingsResource

var quote_nodes : Array

# UI state machine functions
func entering_view() -> void:
	Defaults.active_view_pointer = self
	Defaults.emit_signal("view_changed", title, false, false)
	set_up_btns()
	update_view_text()
	toggle_colour_panel(false)
	
	
func leaving_view() -> void:
	Defaults.save_settings_resource()
	toggle_colour_panel(false)
	
	
func save() -> void:
	Defaults.save_settings_resource()


func _ready() -> void:
	res = Defaults.settings_res
	update_settings()
	update_quotes()


func set_up_btns() -> void:
	$HBX/C/VBoxContainer/FontSize/Option.select(res.font_size)
	$HBX/C/VBoxContainer/SecsDashboard/Option.pressed = res.show_secs_dash
	$HBX/C/VBoxContainer/WindowPos/Option.pressed = res.remember_window_settings
	$HBX/C/VBoxContainer/HidDPI/Option.pressed = res.hidpi
	$HBX/C/VBoxContainer/LongPause/Option.value = res.pomo_long_pause_length
	$HBX/C/VBoxContainer/LongPauseFreq/Option.value = res.pomo_long_pause_freq
	$HBX/C/VBoxContainer/ShortPause/Option.value = res.pomo_short_pause_length
	$HBX/C/VBoxContainer/WorkTimeLength/Option.value = res.pomo_work_time_length
	$HBX/C/VBoxContainer/WindowPos2/Option.pressed = res.remember_last_session_view
	$HBX/C/VBoxContainer/ShowDate/Option.pressed = res.show_date
	$HBX/C/VBoxContainer/Borderless/Option.pressed = res.borderless
	# notes textedit
	$HBX/C/VBoxContainer/LineNumbers/Option.pressed = res.line_numbers
	$HBX/C/VBoxContainer/HighlightLine/Option.pressed = res.highlight_current_line
	$HBX/C/VBoxContainer/Minimap/Option.pressed = res.minimap
	$HBX/C/VBoxContainer/SyntaxHighlighting/Option.pressed = res.syntax_highlighting
	$HBX/C/VBoxContainer/Tabs/Option.pressed = res.draw_tabs
	$HBX/C/VBoxContainer/Spaces/Option.pressed = res.draw_spaces


func update_quotes() -> void:
	for i in res.quote_list:
		var new = $HBX/C/VBoxContainer/QuoteBox.duplicate()
		new.get_child(0).text = str(i)
		new.get_child(2).text = res.quote_list[i]
		new.get_child(1).connect("pressed", self, "on_quote_delete_pressed", [i])
		new.name = "quote" + str(i)
		new.show()
		$HBX/C/VBoxContainer.add_child(new)
		quote_nodes.append(new)


func make_new_quote() -> void:
	res.quote_id += 1
	var idx : int = res.quote_id
	var new = $HBX/C/VBoxContainer/QuoteBox.duplicate()
	new.get_child(0).text = str(idx)
	new.get_child(1).text = "New Quote"
	new.get_child(2).connect("pressed", self, "on_quote_delete_pressed", [idx])
	new.name = "quote" + str(idx)
	new.show()
	$HBX/C/VBoxContainer.add_child(new)
	quote_nodes.append(new)


func save_quotes() -> void:
	for i in quote_nodes:
		print(i.name)
		var text : String = i.get_child(2).text
		res.quote_list[int(i.name.trim_prefix("quote"))] = text
		
	Defaults.save_settings_resource()


func update_settings() -> void:
	Defaults.change_body_font_size(res.font_size)


func update_view_text() -> void:
	var text : String = ""
	Defaults.emit_signal("update_view_info", text)


func toggle_colour_panel(really : bool) -> void:
	$Tween.remove_all()
	$Tween.interpolate_property($HBX/Panel, "rect_min_size:x", $HBX/Panel.rect_min_size.x, 400 * float(really), 0.75, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.0)
	$Tween.interpolate_property($HBX/Panel, "modulate:a", $HBX/Panel.modulate.a, 1.0 * float(really), 0.75, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.0)
	$Tween.start()


# -- > SIGNALS <-- #

func on_quote_delete_pressed(idx : int) -> void:
	res.quote_list.erase(idx)
	$HBX/C/VBoxContainer.get_node("quote" + str(idx)).queue_free()


func _on_Option_item_selected(index: int) -> void:
	res.font_size = index
	Defaults.change_body_font_size(index)


func _on_secsDashboard_toggled(button_pressed: bool) -> void:
	res.show_secs_dash = button_pressed
	
	
func _on_timeFormat_toggled(button_pressed: bool) -> void:
	res.set_24h_time = button_pressed


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


func _on_PomodoroResetButton_pressed() -> void:
	res.reset_pomodoro_settings()
	set_up_btns()


func _on_GeneralResetButton_pressed() -> void:
	res.reset_general_settings()
	set_up_btns()


func _on_ShowDateOption_toggled(button_pressed: bool) -> void:
	res.show_date = button_pressed


func _on_BorderlessOption_toggled(button_pressed: bool) -> void:
	OS.window_borderless = button_pressed
	res.borderless = button_pressed


func _on_lineNumbersOption_toggled(button_pressed: bool) -> void:
	res.line_numbers = button_pressed


func _on_HighlightLineOption_toggled(button_pressed: bool) -> void:
	res.highlight_current_line = button_pressed


func _on_MinimapOption_toggled(button_pressed: bool) -> void:
	res.minimap = button_pressed


func _on_SyntaxHighlightingOption_toggled(button_pressed: bool) -> void:
	res.syntax_highlighting = button_pressed


func _on_TabsOption_toggled(button_pressed: bool) -> void:
	res.draw_tabs = button_pressed


func _on_SpacesOption_toggled(button_pressed: bool) -> void:
	res.draw_spaces = button_pressed


func _on_HighlightOccurancesOption_toggled(button_pressed: bool) -> void:
	res.highlight_all_occurances = button_pressed


func _on_NotesResetButton_pressed() -> void:
	res.reset_notes_settings()
	set_up_btns()


func _on_HiDPI_Option_toggled(button_pressed: bool) -> void:
	res.hidpi = button_pressed
	ProjectSettings.set_setting("display/window/allow_hidpi", button_pressed)
	ProjectSettings.set_setting("gui/theme/hidpi", button_pressed)
	

func _on_NewQuote_pressed() -> void:
	make_new_quote()


func _on_QuotesSaveButton_pressed() -> void:
	save_quotes()


func _on_TheneResetButton_pressed() -> void:
	Defaults.load_default_theme()
	$HBX/C/VBoxContainer/CatTheme.update_values()


func _on_ColorPicker_show_colour_panel(really) -> void:
	toggle_colour_panel(really)
