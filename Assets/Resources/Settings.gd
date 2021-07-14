class_name SettingsResource
extends Resource

export(String) var name = "Name"
export(String) var title = "User title"
export(bool) var particles
export(bool) var always_on_top
export(float) var drag_sensitivity

# window save
export var remember_window_settings : bool = true
export var window_size : Vector2 = Vector2(1100, 650)
export var window_pos : Vector2 = Vector2.ZERO

# minimized window save
export var window_maximized : bool = false
export var minimized_window_position : Vector2
export var minimized_window_size : Vector2 = Vector2(1100, 650)

# settings
export var show_secs_dash : bool = true
# font size is 0 - small, 1 - medium, 2 - large
export var font_size : int = 0
export var remember_last_session_view : bool = false
export var last_session_view : int = -1
export var show_date : bool = true
export var borderless : bool = true

#pomodoro settings
export var pomo_work_time_length : int = 25
export var pomo_short_pause_length : int = 5
export var pomo_long_pause_length : int = 15
export var pomo_long_pause_freq : int = 4

#note taking
export var line_numbers : bool = false
export var syntax_highlighting : bool = false
export var draw_tabs : bool = false
export var draw_spaces : bool = false
export var minimap : bool = true
export var highlight_current_line : bool = false
export var highlight_all_occurances : bool = false

func reset_pomodoro_settings() -> void:
	pomo_long_pause_freq = 4
	pomo_long_pause_length = 15
	pomo_short_pause_length = 5
	pomo_work_time_length = 25
	
	
func reset_general_settings() -> void:
	show_secs_dash = true
	show_date = true
	remember_last_session_view = false
	last_session_view = -1
	remember_window_settings = false
	font_size = 1
	borderless = true


func reset_notes_settings() -> void:
	line_numbers = false
	syntax_highlighting = false
	draw_spaces = false
	draw_tabs = false
	minimap = true
	highlight_current_line = false
	highlight_all_occurances = false
