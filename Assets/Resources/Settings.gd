class_name SettingsResource
extends Resource

const THEME_SAVE_PATH : String = "user://theme.tres"

export(int) var version : int = 0.1

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
export var set_24h_time: bool = true
# font size is 0 - small, 1 - medium, 2 - large
export var font_size : int = 0
export var remember_last_session_view : bool = false
export var last_session_view : int = -1
export var show_date : bool = true
export var twelve_hour_clock : bool = false
export var borderless : bool = true
export var hidpi : bool = false

#pomodoro settings
export var pomo_work_time_length : int = 254
export var pomo_short_pause_length : int = 5
export var pomo_long_pause_length : int = 15
export var pomo_long_pause_freq : int = 3

#note taking
export var line_numbers : bool = false
export var syntax_highlighting : bool = false
export var draw_tabs : bool = false
export var draw_spaces : bool = false
export var minimap : bool = true
export var highlight_current_line : bool = false
export var highlight_all_occurances : bool = false

#user quotes
export var quote_id : int = 10
export var quote_list : Dictionary = {
	1:"A big part of staying productive is knowing when to rest and when to work, take some time off!",
	2:"I hate the \"Don't procrastinate\" gang. What\'s wrong with doing nothing?",
	3:"A long time ago a wise old woman told me that being productive is all about being unpredictable. Being unpredictable in what you'll be doing next. It's the thoughts of work that get you tired before you even begin.",
	4:"See that week old, half eaten apple on your desk? See how juicy it looks? Don't eat it. Gross.",
	5:"Spreadsheetsare for amateurs.",
	6:"Game development is like coming back from hell with a snickers bar in your irght hand and broken mouse in the other.",
	7:"Ever felt like being productive? Me neither.",
	8:"Congratulations! You're ready.",
	9:"Old wisdom foresees that eventually we'll all find happiness where we least expected it.",
	10:"Not to be a bore, but that time tracker ain't gonna turn itself on. Start tracking something now, even if it's nothing."
}

export(bool) var custom_theme : bool = false

export(Resource) var unsaved_time_track

func reset_pomodoro_settings() -> void:
	pomo_long_pause_freq = 3
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

