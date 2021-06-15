extends Node

const DAYS : Array = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
const MONTHS : Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

const NOTES_SAVE_PATH : String = "user://Notes/"
const TIMETRACKS_SAVE_PATH : String = "user://TimeTracks/"
const TIMETRACKS_SAVE_NAME : String = "TimeTrackResource.tres"

export(Color) var btn_active_colour : Color
export(Color) var btn_inactive_colour : Color

var views : Array


func _ready() -> void:
	check_folders()
	
	
func check_folders() -> void:
	var dir : Directory = Directory.new()
	if dir.dir_exists(NOTES_SAVE_PATH):
		print("notes directory exists!")
	else:
		print("notes directory is missing, creating it now")
		dir.make_dir(NOTES_SAVE_PATH)
		
	if dir.dir_exists(TIMETRACKS_SAVE_PATH):
		print("time tracking directory exists!")
	else:
		print("time tracking directory is missing, creating it now")
		dir.make_dir(TIMETRACKS_SAVE_PATH)

	if dir.file_exists(TIMETRACKS_SAVE_PATH + TIMETRACKS_SAVE_NAME):
		print("TimeTracking resource exists!")
	else:
		print("TimeTracking resource missing, creating it now!")
		var resource : TimeTrackResource = TimeTrackResource.new()
		var err : int = ResourceSaver.save(TIMETRACKS_SAVE_PATH + TIMETRACKS_SAVE_NAME, resource)


func quit() -> void:
	for i in views:
		if i.has_method("save"):
			i.save()
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
	var text : String = DAYS[date.day % 7] + ", " + MONTHS[date.month] + " " + str(date.year)
	return text


func get_date_and_time_with_underscores(_custom : Dictionary) -> String:
	var date : Dictionary = OS.get_datetime()
	if _custom.size() > 0:
		date = _custom
	var text : String = str(date.day) + "_" + str(date.month) + "_" + str(date.year) + "_" + str(date.hour) + "_" + str(date.minute) + "_" + str(date.second)
	
	return text


func get_time_with_semicoloumns(_custom : Dictionary) -> String:
	var date : Dictionary = OS.get_datetime()
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


func get_date_with_time_string(_dic : Dictionary) -> String:
	return get_date_as_numbers(_dic) + " " + get_time_with_semicoloumns(_dic)


func save_note_resource(note : NoteResource) -> int:
#	var saver : ResourceSaver = ResourceSaver.new()
	if !note: return 0
	var err : int = ResourceSaver.save(NOTES_SAVE_PATH + note.save_name + ".tres", note)
	return err

func save_timetrack_resource(tt : TimeTrackResource) -> int:
	var err : int = ResourceSaver.save(TIMETRACKS_SAVE_PATH + TIMETRACKS_SAVE_NAME, tt)
	return err
