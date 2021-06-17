class_name WindowRestrictor

func restrict_popup_inside_screen(var popup : Popup):
	var calendar_container = popup.get_parent()
	var popup_container = popup.get_node("PanelContainer")
	
	var popup_x_size = popup_container.get_size().x
	var popup_y_size = popup_container.get_size().y
	var calendar_icon_x_pos = calendar_container.get_global_position().x
	var calendar_icon_y_pos = calendar_container.get_global_position().y
	var calendar_icon_x_size = calendar_container.get_size().x
	var calendar_icon_y_size = calendar_container.get_size().y
	var window_size_x = OS.get_window_size().x
	var window_size_y = OS.get_window_size().y
	
	var pos_x = 0
	if(window_size_x > (popup_x_size + calendar_icon_x_size/2)):
		var popup_x_end = popup_x_size + calendar_icon_x_pos + calendar_icon_x_size/2
		if(window_size_x > popup_x_end):
			pos_x = calendar_icon_x_pos + calendar_icon_x_size/2
		else:
			pos_x = window_size_x - popup_x_size
	
	var pos_y = 0
	if(window_size_y > (popup_y_size + calendar_icon_y_size/2)):
		var popup_y_end = popup_y_size + calendar_icon_y_pos + calendar_icon_y_size/2
		if(window_size_y > popup_y_end):
			pos_y = calendar_icon_y_pos + calendar_icon_y_size/2
		else:
			pos_y = window_size_y - popup_y_size
			
	popup.set_global_position(Vector2(pos_x, pos_y))
