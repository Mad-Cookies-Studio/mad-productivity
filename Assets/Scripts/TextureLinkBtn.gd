extends TextureButton

export(String) var target_link
export(bool) var theme_highlight : = false

func _ready() -> void:
	modulate.a = 0.3
	connect("mouse_entered", self, "on_mouse_entered")
	connect("mouse_exited", self, "on_mouse_exited")
	connect("pressed", self, "on_pressed")
	
	
func on_mouse_exited() -> void:
	modulate = Color.white
	modulate.a = 0.3
	
	
func on_mouse_entered() -> void:
	if theme_highlight:
		modulate = Defaults.ui_theme.highlight_colour
	else:
		modulate = Color.white
	
	
func on_pressed() -> void:
	if target_link:
		OS.shell_open(target_link)
