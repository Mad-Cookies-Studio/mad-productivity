extends Control

var selected_date : Date

var previous_hour : String = "23"
var previous_minute : String = "59"


func _ready() -> void:
	$Panel/VB/VB2/Link/LinkBtn.hide()


func get_datetime_dictionary() -> Dictionary :
	var dic : Dictionary
	dic.day = selected_date.day
	dic.month = selected_date.month
	dic.year = selected_date.year
	dic.hour = int($Panel/VB/VB1/CalendarContainer/Hour.text)
	dic.minute = int($Panel/VB/VB1/CalendarContainer/Minute.text)
	dic.second = 0
	return dic


func get_unix_time() -> int :
	return OS.get_unix_time_from_datetime(get_datetime_dictionary())


func _on_CalendarButton_date_selected(date_obj) -> void:
	selected_date = date_obj
	$Panel/VB/VB1/DateLabel.text = str(date_obj.day) + "/" + str(date_obj.month) + "/" + str(date_obj.year)  


func _on_Hour_text_changed(new_text: String) -> void:
	if new_text == "":
		previous_hour = new_text
		$Panel/VB/VB1/CalendarContainer/Hour.text = previous_hour
		return
		
	if new_text.is_valid_integer() and int(new_text) < 25:
		previous_hour = new_text
	else:
		$Panel/VB/VB1/CalendarContainer/Hour.text = previous_hour


func _on_Minute_text_changed(new_text: String) -> void:
	
	if new_text == "":
		previous_minute = new_text
		$Panel/VB/VB1/CalendarContainer/Minute.text = previous_minute
		return
		
	if new_text.is_valid_integer() and int(new_text) < 60:
		previous_minute = new_text
	else:
		$Panel/VB/VB1/CalendarContainer/Minute.text = previous_minute


func _on_Link_text_changed(new_text: String) -> void:
	if new_text.begins_with("http") or new_text.begins_with("www."):
		$Panel/VB/VB2/Link/LinkBtn.show()
	else:
		$Panel/VB/VB2/Link/LinkBtn.hide()
		

func _on_LinkBtn_pressed() -> void:
	OS.shell_open($Panel/VB/VB2/Link.text)
