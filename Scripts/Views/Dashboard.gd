extends Control

var midnight_check : Dictionary

func _ready() -> void:
	midnight_check = OS.get_time()
	update_time()
	update_date()

func _on_Timer_timeout() -> void:
	update_time()

func entering_view() -> void:
	pass
	
	
func leaving_view() -> void:
	pass


func update_time() -> void:
	$VBoxContainer/Time.text = Defaults.get_time_with_semicoloumns({})
	if OS.get_time().hour < midnight_check.hour:
		update_date()
	
	
	
func update_date() -> void:
	$VBoxContainer/Date.text = Defaults.get_full_date_as_string({})
