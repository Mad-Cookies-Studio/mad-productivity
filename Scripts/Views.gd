extends MarginContainer

func _ready() -> void:
	for i in get_children():
		Defaults.views.append(i)
	hide_all()
	
	
func hide_all() -> void:
	for i in get_children():
		i.hide()
