extends Control

const DAYS : Array = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
const MONTHS : Array = ["January", "Febrruary", "March", "April", "May", "June", "July"]

func _ready() -> void:
	update_time()
	update_date()


func _on_Timer_timeout() -> void:
	update_time()


func update_time() -> void:
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
		
	$VBoxContainer/Time.text = hour + ":" + minute + ":" + second
	
	
func update_date() -> void:
	var date = OS.get_datetime()
	$VBoxContainer/Date.text = DAYS[date.day % 7] + ", " + MONTHS[date.month] + " " + str(date.year)
