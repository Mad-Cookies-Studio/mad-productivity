extends Node

const DAYS : Array = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
const MONTHS : Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

export(Color) var btn_active_colour : Color
export(Color) var btn_inactive_colour : Color


func quit() -> void:
	get_tree().quit()


func get_date_as_numbers() -> String:
	var date : Dictionary = OS.get_datetime()
	
	var date_digits : String = str(date.day % 7) + "/" + str(date.month) + "/" + str(date.year)
	
	return date_digits

func get_full_date_as_string() -> String:
	var date : Dictionary = OS.get_datetime()
	var text : String = DAYS[date.day % 7] + ", " + MONTHS[date.month] + " " + str(date.year)
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
