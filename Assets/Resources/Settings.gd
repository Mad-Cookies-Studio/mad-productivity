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
export var font_size : int = 0
export var remember_last_session_view : bool = false
export var last_session_view : int = -1

#pomodoro settings
export var pomo_work_time_length : int = 10
export var pomo_short_pause_length : int = 10
export var pomo_long_pause_length : int = 10
export var pomo_long_pause_freq : int = 3
