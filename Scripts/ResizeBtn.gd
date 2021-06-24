extends TextureButton

var MIN_WIN_SIZE : Vector2 = Vector2(1100, 650)

var ms_speed : Vector2


func _ready() -> void:
	set_process_input(false)
	

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		ms_speed = event.relative
		OS.window_size.x = clamp(OS.window_size.x + event.relative.x, MIN_WIN_SIZE.x, 10000)
		OS.window_size.y = clamp(OS.window_size.y + event.relative.y, MIN_WIN_SIZE.y, 10000)
	if event is InputEventMouseButton and !event.pressed:
		set_process_input(false)
		Input.set_mouse_mode(0)
		Input.warp_mouse_position(OS.window_size - Vector2(10,14))
	
	
func _on_ResizeBtn_pressed() -> void:
	set_process_input(true)
	Input.set_mouse_mode(2)
