extends MarginContainer

func _ready() -> void:
	hide_all()
	
	
func hide_all() -> void:
	for i in get_children():
		i.hide()
