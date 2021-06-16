extends MarginContainer

signal manual_view_toggle(which)

func _ready() -> void:
	for i in get_children():
		Defaults.views.append(i)
	hide_all()
	
	
func hide_all() -> void:
	for i in get_children():
		i.hide()

func start_custom_time_track(_name) -> void:
	emit_signal("manual_view_toggle", 2)
	$TimeTracking.start_time_tracking_custom(_name)
