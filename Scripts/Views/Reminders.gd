extends Control

export var title : String

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
	final_destination.x += new.rect_size.x + 7
#	final_destination.y = final_destination.y + ((new.rect_size.y / 2 ) - ($ContextOptions.rect_size.y/2))
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
	Defaults.active_view_pointer = self
	Defaults.emit_signal("view_changed", title, false, false)
	active = true
	
	
func leaving_view() -> void:
	move_context_menu_away()
	active = false
	
	
func save() -> void:
	Defaults.save_reminders_resource(res)


# -- functions

func add_reminder(_message : String, _link : String, _remind_date : Dictionary, _remind_date_unix : int) -> void:
	# set base for the ID
	var id : int = res.reminders.size() + 1	
	
	# make sure the ID isnt being used by ant other reminder
	while res.reminders.has(id):
		id += 1
	
	# create the reminder object
	var reminder : = {
		"message" : _message,
		"link" : _link,
		"remind_date" : _remind_date,
		"unix_time" : _remind_date_unix,
		"id" : id
	}
	
	# assign the rmeinder object
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

func move_context_menu_away() -> void:
	$Tween.remove_all()
	$Tween.interpolate_property($ContextOptions, "rect_position", $ContextOptions.rect_position, Vector2(482, -112.859), 1.0, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.0)
	$Tween.start()

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
	
	if $VBoxContainer/Panel/NewReminderContainer/Panel/VB/VB1/DateLabel.text == "00/00/0000":
		return
	add_reminder($VBoxContainer/Panel/NewReminderContainer/Panel/VB/VB2/Message.text,
	$VBoxContainer/Panel/NewReminderContainer/Panel/VB/VB2/Link.text,
	$VBoxContainer/Panel/NewReminderContainer.get_datetime_dictionary(),
	$VBoxContainer/Panel/NewReminderContainer.get_unix_time())
	
	$VBoxContainer/Panel/NewReminderContainer/Panel/VB/VB1/CalendarContainer/Hour.text = "00"
	$VBoxContainer/Panel/NewReminderContainer/Panel/VB/VB1/CalendarContainer/Minute.text = "00"
	$VBoxContainer/Panel/NewReminderContainer/Panel/VB/VB2/Message.text= ""
	$VBoxContainer/Panel/NewReminderContainer/Panel/VB/VB2/Link.text = ""
	
func _on_item_hovered_over(item : ColorRect) -> void:
	set_current_item(item)


func _on_DeleteBtn_pressed() -> void:
	if current_item:
		delete_reminder(current_item.idx)
		current_item.queue_free()
		move_context_menu_away()


func _on_LinkBtn_pressed() -> void:
	if current_item:
		var link : String = res.reminders[current_item.idx].link
		if link.begins_with("www.") or link.begins_with("http"):
			OS.shell_open(link)
			move_context_menu_away()


func _on_Timer_timeout() -> void:
	if $VBoxContainer/Panel/Active/Scroll/VBoxContainer.get_children().size() == 1 :
		return
#		print("just one child. the default one. Boring")
#		return
		
	var child_id : int = 0
	if $VBoxContainer/Panel/Active/Scroll/VBoxContainer.get_child(child_id).idx == 0:
		$VBoxContainer/Panel/Active/Scroll/VBoxContainer.move_child($VBoxContainer/Panel/Active/Scroll/VBoxContainer.get_child(child_id), 1)
		return
		
	if !compare_dates_unix_from_dict(res.reminders[$VBoxContainer/Panel/Active/Scroll/VBoxContainer.get_child(child_id).idx].remind_date, OS.get_datetime()):
		# send a simple os alert to the user.
		# TODO: MAKE THIS PRETTY.
		# Best solution that comes to mind is using the native OS notifications.
		OS.alert(res.reminders[$VBoxContainer/Panel/Active/Scroll/VBoxContainer.get_child(0).idx].message, "Mad productivity alert.")
		# Get the item to move
		var moving_item : ColorRect = $VBoxContainer/Panel/Active/Scroll/VBoxContainer.get_child(0)
		# Move it over to the archive as it no longer needs to be over here
		$VBoxContainer/Panel/Active/Scroll/VBoxContainer.remove_child(moving_item)
		$VBoxContainer/Panel/Archive/Scroll/VBoxContainer.add_child(moving_item)
		# Shake hands and go home
