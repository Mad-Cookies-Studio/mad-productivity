extends TextureButton


func _ready() -> void:
	connect("mouse_entered", self, "mouse_entered")
	connect("mouse_exited", self, "mouse_exited")
	
	
func mouse_entered() -> void:
	modulate.a = 1.0
	
	
func mouse_exited() -> void:
	modulate.a = 0.5
