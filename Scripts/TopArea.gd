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
	Defaults.connect("view_changed", self, "on_view_changed")
	set_process_input(false)
#	$Right/Maximize.pressed = Defaults.settings_res.window_maximized
	

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		drag_amount += event.relative
	OS.window_position.x = clamp(drag_amount.x - orig_position.x, 0, OS.get_screen_size().x - OS.window_size.x)
	OS.window_position.y = clamp(drag_amount.y - orig_position.y, 0, OS.get_screen_size().y - OS.window_size.y)


func _on_TopArea_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			dragging = true

			if OS.window_maximized:
				OS.window_maximized = false
				OS.window_size = Vector2(1100, 700)
				OS.window_position.y = 0
				$Right/Maximize.pressed = false

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


func _on_Maximize_toggled(button_pressed: bool) -> void:
	if button_pressed:
		Defaults.settings_res.minimized_window_size = OS.window_size
		Defaults.settings_res.minimized_window_position = OS.window_position
		Defaults.settings_res.window_maximized = true
		Defaults.save_settings_resource()
		OS.window_maximized = button_pressed
	else:
		OS.window_maximized = false
		Defaults.settings_res.window_maximized = false
		OS.window_size = Defaults.settings_res.minimized_window_size
		OS.window_position = Defaults.settings_res.minimized_window_position
		Defaults.save_settings_resource()
		

func on_view_changed(_name : String, _button : bool, _input_field : bool) -> void:
	$Title/ViewLabel.text = _name
	if _name == "Time tracking":
		$Center/PomodoroBtn.show()
		$Center/NewBtn.hide()
	else:
		$Center/PomodoroBtn.hide()
		$Center/LineEdit.visible = _input_field
		$Center/NewBtn.visible = _button


func _on_Button_pressed() -> void:
	if Defaults.active_view_pointer and Defaults.active_view_pointer.has_method("on_new_top_bar_button"):
		Defaults.active_view_pointer.on_new_top_bar_button({})
