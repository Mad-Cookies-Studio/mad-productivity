tool
extends TextureButton

signal date_selected(date_obj)

var calendar : Node = load("res://addons/calendar_button/class/Calendar.gd").new()
var selected_date := Date.new()
var window_restrictor := WindowRestrictor.new()

var popup : Popup
var calendar_buttons : CalendarButtons

func _enter_tree():
	set_toggle_mode(true)
#	setup_calendar_icon()
	popup = create_popup_scene()
	calendar_buttons = create_calendar_buttons()
	setup_month_and_year_signals(popup)
	refresh_data()

func setup_calendar_icon():
	var normal_texture := create_button_texture("btn_32x32_03.png")
	set_normal_texture(normal_texture)

	var pressed_texture := create_button_texture("btn_32x32_04.png")
	set_pressed_texture(pressed_texture)

func create_button_texture(var image_name : String) -> ImageTexture:
	var image_normal := Image.new()
	image_normal.load("res://addons/calendar_button/btn_img/" + image_name)
	var image_texture_normal := ImageTexture.new()
	image_texture_normal.create_from_image(image_normal)
	return image_texture_normal
	
func create_popup_scene() -> Popup:
	return preload("res://addons/calendar_button/popup.tscn").instance() as Popup

func create_calendar_buttons() -> CalendarButtons:
	var calendar_container : GridContainer = popup.get_node("PanelContainer/vbox/hbox_days")
	return CalendarButtons.new(self, calendar_container)

func setup_month_and_year_signals(popup : Popup):
	var month_year_path = "PanelContainer/vbox/hbox_month_year/"
	popup.get_node(month_year_path + "button_prev_month").connect("pressed",self,"go_prev_month")
	popup.get_node(month_year_path + "button_next_month").connect("pressed",self,"go_next_month")
	popup.get_node(month_year_path + "button_prev_year").connect("pressed",self,"go_prev_year")
	popup.get_node(month_year_path + "button_next_year").connect("pressed",self,"go_next_year")

func set_popup_title(title : String):
	var label_month_year_node := popup.get_node("PanelContainer/vbox/hbox_month_year/label_month_year") as Label
	label_month_year_node.set_text(title)

func refresh_data():
	var title : String = str(calendar.get_month_name(selected_date.month()) + " " + str(selected_date.year()))
	set_popup_title(title)
	calendar_buttons.update_calendar_buttons(selected_date)

func day_selected(btn_node):
	close_popup()
	var day := int(btn_node.get_text())
	selected_date.set_day(day)
	emit_signal("date_selected", selected_date)

func go_prev_month():
	selected_date.change_to_prev_month()
	refresh_data()

func go_next_month():
	selected_date.change_to_next_month()
	refresh_data()

func go_prev_year():
	selected_date.change_to_prev_year()
	refresh_data()

func go_next_year():
	selected_date.change_to_next_year()
	refresh_data()

func close_popup():
	popup.hide()
	set_pressed(false)

func _toggled(is_pressed):
	if(!has_node("popup")):
		add_child(popup)
		popup.rect_global_position =  (popup.rect_size /2 ) + (OS.window_size / 2)
	if(!is_pressed):
		close_popup()
	else:
		if(has_node("popup")):
			popup.show()
		else:
			add_child(popup)
	
	window_restrictor.restrict_popup_inside_screen(popup)
