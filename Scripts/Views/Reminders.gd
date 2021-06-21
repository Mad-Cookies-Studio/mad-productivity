extends Control

var active : = false

var res : ReminderResource
var active_reminders : Array
var archived_reminders : Array
var current_item : ColorRect setget set_current_item

var previously_added_date : Dictionary = {
	"day" : 1,
	"month" : 1,
	"year" : 1991,
	"hour" : 1,
	"minute" : 1,
	"second" : 1
}

func set_current_item(new: ColorRect) -> void:
	if new == current_item: return
	# TODO: Implement a tween over here.
	$Tween.remove_all()
	var final_destination : Vector2 = new.rect_global_position
	final_destination.x += new.rect_size.x - 1
	$Tween.interpolate_property($ContextOptions, "rect_global_position", $ContextOptions.rect_global_position, final_destination, 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.0)
	$Tween.interpolate_property($ContextOptions, "modulate:a", 0.0, 1.0, 1.5, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.0)
	$Tween.start()
	current_item = new

func _ready() -> void:
	res = load_resource()
	populate_arrays()
	populate_reminders()


# -- view state machine functions

func entering_view() -> void:
	active = true
	
	
func leaving_view() -> void:
	active = false
	
	
func save() -> void:
	Defaults.save_reminders_resource(res)


# -- functions

func add_reminder(_message : String, _link : String, _remind_date : Dictionary, _remind_date_unix : int) -> void:
	var id : int = res.reminders.size() + 1
	var reminder : = {
		"message" : _message,
		"link" : _link,
		"remind_date" : _remind_date,
		"unix_time" : _remind_date_unix,
		"id" : id
	}
	res.reminders[id] = reminder
	
	var new : ColorRect = create_new_reminder_visual(_message, _link, _remind_date, id)
	
	if compare_dates_unix(_remind_date_unix, OS.get_unix_time()):
		active_reminders.append(reminder)
		$VBoxContainer/Panel/Active/Scroll/VBoxContainer.add_child(new)
	else:
		$VBoxContainer/Panel/Archive/Scroll/VBoxContainer.add_child(new)
		archived_reminders.append(reminder)

	

func load_resource() -> ReminderResource:
	return load(Defaults.REMINDERS_SAVE_PATH + Defaults.REMINDERS_SAVE_NAME) as ReminderResource
	
	
func populate_reminders(force : bool = false) -> void:
	for i in active_reminders:
		var new : ColorRect = create_new_reminder_visual(i.message, i.link, i.remind_date, i.id)
		$VBoxContainer/Panel/Active/Scroll/VBoxContainer.add_child(new)
		if !compare_dates_unix_from_dict(i.remind_date, previously_added_date):
			$VBoxContainer/Panel/Active/Scroll/VBoxContainer.move_child(new, 0)
		previously_added_date = i.remind_date

	for i in archived_reminders:
		var new : ColorRect = create_new_reminder_visual(i.message, i.link, i.remind_date, i.id)
		$VBoxContainer/Panel/Archive/Scroll/VBoxContainer.add_child(new)
		if !compare_dates_unix_from_dict(i.remind_date, previously_added_date):
			$VBoxContainer/Panel/Archive/Scroll/VBoxContainer.move_child(new, 0)
		previously_added_date = i.remind_date


func create_new_reminder_visual(_comment : String, _link : String, _date : Dictionary, _id) -> ColorRect:
	var new : ColorRect = $VBoxContainer/Panel/Active/Scroll/VBoxContainer/ReminderItem.duplicate()
	new.connect("update_message", self, "_on_item_message_update")
	new.connect("update_link", self, "_on_item_link_update")
	new.connect("hovered_over", self, "_on_item_hovered_over", [new])
	new.populate(_comment, _link, _date, _id)
	new.show()
	
	return new


func populate_arrays() -> void:
	print("printing reminders")
	for i in res.reminders:
		var item = res.reminders[i]
		if compare_dates_unix_from_dict(item.remind_date, OS.get_datetime()):
			active_reminders.append(item)
		else:
			archived_reminders.append(item)


static func compare_dates_unix(new_date : int, comparing_date : int) -> bool:
	return new_date > comparing_date


static func compare_dates_unix_from_dict(new_date : Dictionary, comparing_date : Dictionary) -> bool:
	return OS.get_unix_time_from_datetime(new_date) > OS.get_unix_time_from_datetime(comparing_date)


func update_reminder_message(new: String, idx : int) -> void:
	res.reminders[idx].message = new


func update_reminder_link(new: String, idx : int) -> void:
	res.reminders[idx].link = new


func delete_reminder(idx : int) -> void:
	res.reminders.erase(idx)

# -- signals

func _on_item_message_update(text : String, idx : int) -> void:
	update_reminder_message(text, idx)
	
	
func _on_item_link_update(text : String, idx : int) -> void:
	update_reminder_link(text, idx)
	

func _on_NewReminder_pressed() -> void:
	add_reminder($VBoxContainer/Panel/NewReminderContainer/VBoxContainer/Message.text, $VBoxContainer/Panel/NewReminderContainer/VBoxContainer/Link.text, $VBoxContainer/Panel/NewReminderContainer.get_datetime_dictionary(), $VBoxContainer/Panel/NewReminderContainer.get_unix_time())
	
func _on_item_hovered_over(item : ColorRect) -> void:
	set_current_item(item)


func _on_DeleteBtn_pressed() -> void:
	if current_item:
		delete_reminder(current_item.idx)
		current_item.queue_free()


func _on_LinkBtn_pressed() -> void:
	if current_item:
		var link : String = res.reminders[current_item.idx].link
		if link.begins_with("www.") or link.begins_with("http"):
			OS.shell_open(link)


func _on_Timer_timeout() -> void:
	if $VBoxContainer/Panel/Active/Scroll/VBoxContainer.get_child(0).idx == 0:
		$VBoxContainer/Panel/Active/Scroll/VBoxContainer.move_child($VBoxContainer/Panel/Active/Scroll/VBoxContainer.get_child(0), 1)
	if !compare_dates_unix_from_dict(res.reminders[$VBoxContainer/Panel/Active/Scroll/VBoxContainer.get_child(0).idx].remind_date, OS.get_datetime()):
		OS.alert(res.reminders[$VBoxContainer/Panel/Active/Scroll/VBoxContainer.get_child(0).idx].message, "Mad productivity alert.")
		var moving_item : ColorRect = $VBoxContainer/Panel/Active/Scroll/VBoxContainer.get_child(0)
		$VBoxContainer/Panel/Active/Scroll/VBoxContainer.remove_child(moving_item)
		$VBoxContainer/Panel/Archive/Scroll/VBoxContainer.add_child(moving_item)
		
