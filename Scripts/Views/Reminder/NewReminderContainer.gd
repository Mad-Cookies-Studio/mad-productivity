extends Control

var selected_date : Date

var previous_hour : String = "23"
var previous_minute : String = "23"

func _on_CalendarButton_date_selected(date_obj) -> void:
	selected_date = date_obj
	$VBoxContainer2/DateLabel.text = str(date_obj.day) + "/" + str(date_obj.month) + "/" + str(date_obj.year)  


func _on_Hour_text_changed(new_text: String) -> void:
	if new_text == "":
		previous_hour = new_text
		$VBoxContainer2/CalendarContainer/Hour.text = previous_hour
		return
		
	if new_text.is_valid_integer() and int(new_text) < 25:
		previous_hour = new_text
	else:
		$VBoxContainer2/CalendarContainer/Hour.text = previous_hour


func _on_Minute_text_changed(new_text: String) -> void:
	
	if new_text == "":
		previous_minute = new_text
		$VBoxContainer2/CalendarContainer/Minute.text = previous_minute
		return
		
	if new_text.is_valid_integer() and int(new_text) < 60:
		previous_minute = new_text
	else:
		$VBoxContainer2/CalendarContainer/Minute.text = previous_minute
