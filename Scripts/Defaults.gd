extends Node

enum RESOURCES {NOTES, TIME_TRACK, TODOS, REMINDER, SETTINGS}

const DAYS : Array = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
const MONTHS : Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

## save paths
const NOTES_SAVE_PATH : String = "user://Notes/"
const TIMETRACKS_SAVE_PATH : String = "user://TimeTracks/"
const TIMETRACKS_SAVE_NAME : String = "TimeTrackResource.tres"
const TODOS_SAVE_PATH : String = "user://Todos/"
const TODOS_SAVE_NAME : String = "Todos.tres"
const SETTINGS_SAVE_PATH : String = "user://"
const SETTINGS_SAVE_NAME : String = "Settings.tres"

signal view_changed(_name, _button, _input_field)
signal theme_changed

export(Color) var btn_active_colour : Color
export(Color) var btn_inactive_colour : Color

export(Color) var custom_check_box_active : Color
export(Color) var custom_check_box_inactive : Color


var views : Array
var active_view : int
var active_view_pointer

var time_tracking : bool = false
var time_tracked : int = 0
var item_tracked : String = ""

var time_tracking_panel

var settings_res : SettingsResource

var ui_theme : ThemeResource

var windows_sdt_bias : int

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		quit()

func _ready() -> void:
	set_windows_dst_bias()
	randomize()
	check_folders()
	load_settings()
	init_window()
	load_theme_res()
	update_theme()
	
	
func check_folders() -> void:
	var dir : Directory = Directory.new()
	check_directory(dir, NOTES_SAVE_PATH)
	check_directory(dir, TIMETRACKS_SAVE_PATH)
	check_directory(dir, TODOS_SAVE_PATH)
	check_resource(dir, TIMETRACKS_SAVE_PATH + TIMETRACKS_SAVE_NAME, RESOURCES.TIME_TRACK)
	check_resource(dir, TODOS_SAVE_PATH + TODOS_SAVE_NAME, RESOURCES.TODOS)
	check_resource(dir, SETTINGS_SAVE_PATH + SETTINGS_SAVE_NAME, RESOURCES.SETTINGS)


func check_directory(dir : Directory, path : String) -> void:
	if dir.dir_exists(path):
		print("directory exists!")
	else:
		print("directory is missing, creating it now")
		dir.make_dir(path)
		
		
func check_resource(dir: Directory, path : String, resource_id : int) -> void:
	if dir.file_exists(path):
		print("Resource exists!")
	else:
		var resource
		match resource_id:
			RESOURCES.NOTES:
				pass
			RESOURCES.TIME_TRACK:
				resource = TimeTrackResource.new()
				print("Time tracking resource missing, creating it now!")
			RESOURCES.TODOS:
				resource = ToDoResource.new()
				print("Todo resource missing, creating it now!")
			RESOURCES.SETTINGS:
				resource = SettingsResource.new()
				
		var err : int = ResourceSaver.save(path, resource)
		

func load_settings() -> void:
	settings_res = load(SETTINGS_SAVE_PATH + SETTINGS_SAVE_NAME)


func init_window() -> void:
	if settings_res.remember_window_settings:
		OS.window_size = settings_res.window_size
		OS.window_position = settings_res.window_pos
	else:
		OS.center_window()


func load_theme_res() -> void:
	var dir : Directory = Directory.new()
	if dir.file_exists(settings_res.THEME_SAVE_PATH):
		ui_theme = load(settings_res.THEME_SAVE_PATH)
	else:
		ui_theme = load("res://Assets/Themes/Resources/DarkGrey.tres")


func load_default_theme() -> void:
	ui_theme = load("res://Assets/Themes/Resources/DarkGrey.tres").duplicate()
	ui_theme.save_theme()
	update_theme()


func update_theme() -> void:
	ui_theme.update_theme_values()
	# commented and prepared to be used in the onset future
	get_tree().call_group("UI_THEME", "update_theme")
	
	# load the styles
	var panel_dark : StyleBoxFlat = load("res://Assets/Themes/Dark/PanelDarkGreen.tres")
	var panel_dark_border : StyleBoxFlat = load("res://Assets/Themes/Dark/PanelDarkGreenBorder.tres")
	var panel_dark_border_expanded : StyleBoxFlat = load("res://Assets/Themes/Dark/PanelDarkGreenBorderExpanded.tres")
	var panel_normal : StyleBoxFlat = load("res://Assets/Themes/Dark/PanelGreen.tres")
	var panel_normal_no_border : StyleBoxFlat = load("res://Assets/Themes/Dark/PanelGreenNoBorder.tres")
	var panel_highlight : StyleBoxFlat = load("res://Assets/Themes/Dark/PanelHighlight.tres")
	var panel_super_dark : StyleBoxFlat = load("res://Assets/Themes/Dark/PanelSuperDarkGreen.tres")
	var line_edit : StyleBoxFlat = load("res://Assets/Themes/Dark/LineEditTop.tres")
	
	
	# apply colours to styles
	panel_dark.bg_color = ui_theme.darker
	panel_dark_border.bg_color = ui_theme.darker
	panel_dark_border_expanded.bg_color = ui_theme.darker
	panel_normal.bg_color = ui_theme.normal
	panel_normal_no_border.bg_color = ui_theme.normal
	panel_highlight.bg_color = ui_theme.highlight_colour
	panel_super_dark.bg_color = ui_theme.super_dark
	line_edit.bg_color = ui_theme.super_dark
	line_edit.border_color = ui_theme.highlight_colour
	line_edit.border_color.a = 0.3


	## Cute button theme
	var cute_button_theme : Theme = load("res://Assets/Themes/CuteButtonTheme.tres")
	# normal
	cute_button_theme.get_stylebox("normal", "Button").bg_color = ui_theme.highlight_colour
	# hover
	cute_button_theme.get_stylebox("hover", "Button").bg_color = ui_theme.highlight_lighter
	# pressed
	cute_button_theme.get_stylebox("pressed", "Button").bg_color = ui_theme.highlight_darker

	## Roboto 12 clean theme
	var roboto_clean : Theme = load("res://Assets/Themes/Roboto12Clean.tres")
	# colors
	roboto_clean.set_color("selection_color", "LineEdit", ui_theme.highlight_colour)
	roboto_clean.set_color("cursor_color", "LineEdit", ui_theme.highlight_colour)

	## PopUp theme
	var popupTheme : Theme = load("res://Assets/Themes/PopupTheme.tres")
	# colors
	popupTheme.set_color("font_color_hover", "Button", ui_theme.highlight_colour)
	# set up local colours
	btn_active_colour = ui_theme.btn_active_col
	btn_inactive_colour = ui_theme.btn_inactive_col
	
	## checkbox theme
	var checkbox_theme : Theme = load("res://Assets/Themes/CheckBox.tres")
	# pop up panel
	checkbox_theme.get_stylebox("panel", "PopupMenu").bg_color = ui_theme.normal
	checkbox_theme.get_stylebox("hover", "PopupMenu").bg_color = ui_theme.darker
	checkbox_theme.set_color("font_color_hover", "PopupMenu", ui_theme.highlight_colour)
	# options button
	checkbox_theme.get_stylebox("normal", "OptionButton").bg_color = ui_theme.darker
	checkbox_theme.get_stylebox("hover", "OptionButton").bg_color = ui_theme.normal
	checkbox_theme.set_color("font_color_pressed", "OptionButton", ui_theme.highlight_colour)
	checkbox_theme.set_color("font_color_hover", "OptionButton", ui_theme.highlight_colour)
	# line edit
	checkbox_theme.set_color("cursor_color", "LineEdit", ui_theme.highlight_colour)
	checkbox_theme.set_color("selection_color", "LineEdit", ui_theme.highlight_colour)
	
	## charge button theme
	var charge_theme : Theme = load("res://Assets/Themes/ChargeButtonTheme.tres")
	# button panels
	charge_theme.get_stylebox("hover", "Button").border_color = ui_theme.highlight_colour
	charge_theme.get_stylebox("pressed", "Button").border_color = ui_theme.highlight_colour
	# button colours
	charge_theme.set_color("font_color_pressed", "Button", ui_theme.highlight_colour)
	charge_theme.set_color("font_color_hover", "Button", ui_theme.highlight_colour)
	
	
	emit_signal("theme_changed")



func quit() -> void:
	# trigger the save function in all the views
	for i in views:
		if i.has_method("save"):
			i.save()
	
	# save the last window position
	if settings_res.remember_window_settings:
		settings_res.window_pos = OS.window_position
		settings_res.window_size = OS.window_size
		
	if settings_res.remember_last_session_view:
		settings_res.last_session_view = active_view
	
	if time_tracking_panel:
		time_tracking_panel.quit()
	
	ui_theme.save_theme()
	save_settings_resource()
	
	
	get_tree().quit()


func get_date_as_numbers(_custom : Dictionary) -> String:
	var date : Dictionary = OS.get_datetime()
	if _custom.size() > 0:
		date = _custom
	var date_digits : String = str(date.day) + "/" + str(date.month) + "/" + str(date.year)
	
	return date_digits

func get_full_date_as_string(_custom : Dictionary) -> String:
	var date : Dictionary = OS.get_datetime()
	if _custom.size() > 0:
		date = _custom
	var text : String = DAYS[date.weekday - 1] + ", " + str(date.day)+ " " + MONTHS[date.month - 1] + " " + str(date.year)
	return text


func get_date_and_time_with_underscores(_custom : Dictionary) -> String:
	var date : Dictionary = OS.get_datetime()
	if _custom.size() > 0:
		date = _custom
	var text : String = str(date.day) + "_" + str(date.month) + "_" + str(date.year) + "_" + str(date.hour) + "_" + str(date.minute) + "_" + str(date.second)
	
	return text


func get_time_with_semicoloumns(_custom : Dictionary) -> String:
	var date : Dictionary = OS.get_time()
	if _custom.size() > 0:
		date = _custom
	var hour : String = str(date.hour)
	var minute : String = str(date.minute)
	var second : String = str(date.second)
	if hour.length() == 1:
		hour = "0" + hour
	if minute.length() == 1:
		minute = "0" + minute
	if second.length() == 1:
		second = "0" + second
		
	return hour + ":" + minute + ":" + second


func get_time_with_semicoloumns_no_secs(_custom : Dictionary) -> String:
	var date : Dictionary = OS.get_time()
	if _custom.size() > 0:
		date = _custom
	var hour : String = str(date.hour)
	var minute : String = str(date.minute)
	if hour.length() == 1:
		hour = "0" + hour
	if minute.length() == 1:
		minute = "0" + minute
		
	return hour + ":" + minute


func get_date_with_time_string(_dic : Dictionary) -> String:
	return get_date_as_numbers(_dic) + " " + get_time_with_semicoloumns(_dic)

func get_datetime_from_unix_time(_unixTime : int) -> String:
	# timezone and dst
	var bias = Defaults.get_time_zone_bias()
	_unixTime += bias * 60
	return get_date_with_time_string(OS.get_datetime_from_unix_time(_unixTime))


func get_formatted_time_from_seconds(_secs : int) -> String:
	var neg : bool = false
	if _secs < 0: 
		_secs = abs(_secs)
		neg = true
	var hours : int = _secs / 3600
	_secs -= hours * 3600
	var minutes : int = _secs / 60
	_secs -= minutes * 60
	
	if neg:
		return ("-" + "%02d" % hours) + ":" + str("%02d" % minutes) + ":" + ("%02d" % _secs)
	else:
		return ("%02d" % hours) + ":" + str("%02d" % minutes) + ":" + ("%02d" % _secs)


func save_note_resource(note : NoteResource) -> int:
#	var saver : ResourceSaver = ResourceSaver.new()
	if !note: return 0
	var err : int = ResourceSaver.save(NOTES_SAVE_PATH + note.save_name + ".tres", note)
	return err


func save_timetrack_resource(tt : TimeTrackResource) -> int:
	var err : int = ResourceSaver.save(TIMETRACKS_SAVE_PATH + TIMETRACKS_SAVE_NAME, tt)
	return err
	
	
func save_todo_resource(td : ToDoResource) -> int:
	var err : int = ResourceSaver.save(TODOS_SAVE_PATH + TODOS_SAVE_NAME, td)
	return err



func save_settings_resource(sr : SettingsResource = null) -> int:
	var res : SettingsResource = settings_res
	if sr != null:
		res = sr
	var err : int = ResourceSaver.save(SETTINGS_SAVE_PATH + SETTINGS_SAVE_NAME, res)
	return err


func change_body_font_size(index : int) -> void:
	var size : = 12
	if index == 1:
		size = 14
	elif index == 2:
		size = 18
	var font_res : DynamicFont = load("res://Assets/Fonts/Roboto12.tres")
	font_res.size = size
	save_settings_resource()


func set_windows_dst_bias() -> void:
	if OS.get_name() == "Windows":
		var output = []
		OS.execute('WMIC.exe', ["OS","Get","CurrentTimeZone"],true, output)
		windows_sdt_bias = int(output[0].split("\n")[1])

func get_time_zone_bias() -> int:
	if OS.get_name() == "Windows":
		return windows_sdt_bias
	else:
		return OS.get_time_zone_info()['bias']
