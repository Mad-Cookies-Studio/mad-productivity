extends Node

const DAYS : Array = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
const MONTHS : Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

const NOTES_SAVE_PATH : String = "user://Notes/"

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
		print("notes directory is missing creating")
		dir.make_dir(NOTES_SAVE_PATH)
		


func quit() -> void:
	for i in views:
		if i.has_method("save"):
			i.save()
	get_tree().quit()


func get_date_as_numbers() -> String:
	var date : Dictionary = OS.get_datetime()
	
	var date_digits : String = str(date.day) + "/" + str(date.month) + "/" + str(date.year)
	
	return date_digits

func get_full_date_as_string() -> String:
	var date : Dictionary = OS.get_datetime()
	var text : String = DAYS[date.day % 7] + ", " + MONTHS[date.month] + " " + str(date.year)
	return text


func get_date_and_time_with_underscores() -> String:
	var date : Dictionary = OS.get_datetime()
	var text : String = str(date.day) + "_" + str(date.month) + "_" + str(date.year) + "_" + str(date.hour) + "_" + str(date.minute) + "_" + str(date.second)
	
	return text


func get_time_with_semicoloumns() -> String:
	var date = OS.get_datetime()
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


func save_note_resource(note : NoteResource) -> int:
#	var saver : ResourceSaver = ResourceSaver.new()
	if !note: return 0
	var err : int = ResourceSaver.save(NOTES_SAVE_PATH + note.save_name + ".tres", note)
	print(err)
	return err
