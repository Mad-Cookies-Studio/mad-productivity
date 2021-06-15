extends Control

var dragging : = false
var mouse_drag_beg : Vector2
var orig_position : Vector2
var drag_amount : Vector2

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
			print(get_global_mouse_position())

			set_process_input(true)
		else:
			dragging = false
			set_process_input(false)


func _on_Minimuze_pressed() -> void:
	OS.window_minimized = true


func _on_Exit_pressed() -> void:
	Defaults.quit()
