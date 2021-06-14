extends Control

func _ready() -> void:
	update_time()
	update_date()


func _on_Timer_timeout() -> void:
	update_time()


func update_time() -> void:
	$VBoxContainer/Time.text = Defaults.get_time_with_semicoloumns()
	
	
func update_date() -> void:
	$VBoxContainer/Date.text = Defaults.get_full_date_as_string()
