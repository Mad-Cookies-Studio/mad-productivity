extends Control

var dragging : = false
var mouse_drag_beg : Vector2
var orig_position : Vector2
var drag_amount : Vector2

var initial_mouse_pos : Vector2

var maximized : bool = false
var minimized_size : Vector2
var minimized_pos : Vector2

func _ready() -> void:
	set_process_input(false)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		drag_amount += event.relative
	OS.window_position = drag_amount - orig_position


func _on_TopArea_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			dragging = true
#			mouse_drag_beg = get_viewport().get_mouse_position()
			orig_position = get_viewport().get_mouse_position() - OS.window_position
			drag_amount = get_viewport().get_mouse_position()
#			print(get_global_mouse_position())
			initial_mouse_pos = get_local_mouse_position()
			Input.set_mouse_mode(2)

			set_process_input(true)
		else:
			dragging = false
			set_process_input(false)
			Input.set_mouse_mode(0)
			Input.warp_mouse_position(initial_mouse_pos)


func _on_Minimuze_pressed() -> void:
	OS.window_minimized = true


func _on_Exit_pressed() -> void:
	Defaults.quit()


func _on_Maximize_pressed() -> void:
	OS.window_maximized = !maximized
	maximized = !maximized
