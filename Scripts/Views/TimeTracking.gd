extends Control

signal toggle_time_track(_name, really)

export var title : String
var res : TimeTrackResource

var total_secs : int

var active : bool = false

func _ready() -> void:
	$LinearTimeTrackingContainer/ScrollContainer/VBoxContainer/TrackedItem.hide()
	Defaults.connect("theme_changed", self, "on_theme_changed")
	if res == null:
		load_res()
	load_time_tracks()
	update_total_time()
	check_tracks_count()


func load_res() -> void:
	res = load(Defaults.TIMETRACKS_SAVE_PATH + Defaults.TIMETRACKS_SAVE_NAME)


func entering_view() -> void:
	active = true
	Defaults.active_view_pointer = self
	Defaults.emit_signal("view_changed", title, true, false)
	update_view_text()
	
	
func leaving_view() -> void:
	active = false
	save()
	
	
func load_time_tracks() -> void:
	var unfinished_track : bool = false
	for i in res.tracks:
		var item = res.tracks[i]
		if item.is_finished():
			create_track_visual(item.name, item.get_start_unix_time(), item.get_len(), i)
		else:
			print("deleting item:")
			print(item.name)
			print("as it was unfinished")
			res.tracks.erase(item)
	
	
func create_track_visual(_name : String, _date : int, _time : int, _id : int) -> void:
	var new : ColorRect = $LinearTimeTrackingContainer/ScrollContainer/VBoxContainer/TrackedItem.duplicate()
	new.id = _id
	
	var time = get_hours_minutes_seconds(_time)
	new.connect("delete_pressed", self, "_on_delete_pressed")
	new.connect("new_tracked_item_text", self, "_on_new_time_track_item_text")
	
	new.fill_details(Defaults.get_datetime_from_unix_time(_date), (time[2] + ":" + time[1] + ":" + time[0]), _name)

	new.show()
	$LinearTimeTrackingContainer/ScrollContainer/VBoxContainer.add_child(new)
	$LinearTimeTrackingContainer/ScrollContainer/VBoxContainer.move_child(new, 1)
	new.show_up()
	
	

func get_hours_minutes_seconds(_time : int) -> Array:
	# calculate
	var seconds : = str(_time % 60)
	var temp_hours : int = (_time / 60) / 60
	var minutes : int = (_time / 60) - (60 * temp_hours)
	var hours : = str(temp_hours)
	#stylize
	seconds = ("%02d" % int(seconds))
	var temp_minutes : String = ("%02d" % minutes)
	hours = "%02d" % int(hours)

	return [seconds, temp_minutes, hours]
	
	
func save() -> void:
	Defaults.save_timetrack_resource(res)



func update_total_time() -> void:
	pass
#	var _time : Array = get_hours_minutes_seconds(total_secs)
#	$CommandPanel/Total.text = "total " + _time[2] + ":" + _time[1] + ":" + _time[0]


func remove_time_track(idx : int) -> void:
	#total_secs -= res.tracks[idx].length
	res.tracks.erase(idx)
	update_total_time()
	check_tracks_count()


func update_time_track_item_text(_text : String, _id : int) -> void:
	res.tracks[_id].name = _text


func update_theme() -> void:
	$Gradient.modulate = Defaults.ui_theme.darker
	
	
func update_view_text() -> void:
	if !active : return
	var text : String = ""
	var secs : int = 0
	
	for i in $LinearTimeTrackingContainer/ScrollContainer/VBoxContainer.get_children():
		secs += res.get_track(i.id).get_duration()
	
	text = "Total tracked: " + Defaults.get_formatted_time_from_seconds(secs)
	
	Defaults.emit_signal("update_view_info", text)
	
	
## SIGNALS
	
func on_theme_changed() -> void:
	update_theme()

		
func _on_delete_pressed(idx : int) -> void:
	remove_time_track(idx)
	
	
func _time_track_item_pressed(_name : String) -> void:
	pass # todo


func _on_new_time_track_item_text(_text : String, _idx : int) -> void:
	update_time_track_item_text(_text, _idx)


func _on_TimeTrackingPanel_register_time_track_item(item : TimeTrackItem) -> void:
	var id : int = res.add_finished_track(item)
	create_track_visual(item.name, item.get_start_unix_time(), item.get_duration(), id)
	update_view_text()
	check_tracks_count()

func check_tracks_count() -> void:
	$NoDataText.visible = res.tracks.size() == 0
