extends TextureButton


func _ready() -> void:
	connect("mouse_entered", self, "mouse_entered")
	connect("mouse_exited", self, "mouse_exited")
	connect("toggled", self, "on_toggled")
	update_colours()
	
	
func update_colours() -> void:
	if pressed:
		modulate = Defaults.btn_active_colour
	else:
		modulate = Defaults.btn_inactive_colour
	
	
func mouse_entered() -> void:
	modulate = Defaults.btn_active_colour
	
	
func mouse_exited() -> void:
	if !pressed:
		modulate = Defaults.btn_inactive_colour


func on_toggled(really : bool) -> void:
	if really:
		modulate = Defaults.btn_active_colour
	else:
		modulate = Defaults.btn_inactive_colour
