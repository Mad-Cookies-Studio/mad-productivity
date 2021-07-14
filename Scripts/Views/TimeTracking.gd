extends Control

signal toggle_time_track(_name, really)

export var title : String
var res : TimeTrackResource
var time_tracks_array : Array
var cancel : = false

var total_secs : int

func _ready() -> void:
	res = load(Defaults.TIMETRACKS_SAVE_PATH + Defaults.TIMETRACKS_SAVE_NAME)
	load_time_tracks()
	update_total_time()


func entering_view() -> void:
	Defaults.active_view_pointer = self
	Defaults.emit_signal("view_changed", title, true, false)
	
	
func leaving_view() -> void:
	save()
	
	
func load_time_tracks() -> void:
	for i in res.tracks:
		var item = res.tracks[i]
		
		item["id"] = i
		time_tracks_array.append(item)
		
	for i in time_tracks_array:
		total_secs += i["length"]
		create_track_visual(i["name"], i["date"], i["length"], i["id"])
	
	
func create_track_visual(_name : String, _date : Dictionary, _time : int, _id : int) -> void:
	var new : ColorRect = $LinearTimeTrackingContainer/ScrollContainer/VBoxContainer/TrackedItem.duplicate()
	new.id = _id
	
	var time = get_hours_minutes_seconds(_time)
	new.connect("delete_pressed", self, "_on_delete_pressed")
	new.connect("time_track_item", self, "_time_track_item_pressed")
	new.connect("new_tracked_item_text", self, "_on_new_time_track_item_text")
	
	new.fill_details(Defaults.get_date_with_time_string(_date), (time[2] + ":" + time[1] + ":" + time[0]), _name)

	new.show()
	$LinearTimeTrackingContainer/ScrollContainer/VBoxContainer.add_child(new)
	$LinearTimeTrackingContainer/ScrollContainer/VBoxContainer.move_child(new, 1)
	new.show_up()
	
	
func add_time_track(_length : int, _name : String, _date : Dictionary) -> void:
	total_secs += _length
	update_total_time()
	res.tracks[res.tracks.size() + 1] = {
		"date" : _date,
		"length" : _length,
		"name" : _name
	}
	create_track_visual(_name, _date, _length, res.tracks.size())
	
	
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
	print("saving time tracking resource")
	Defaults.save_timetrack_resource(res)


func start_time_tracking_custom(_name) -> void:
	if Defaults.time_tracking : return
	$LinearTimeTrackingContainer/Panel/Label.text = _name
	$LinearTimeTrackingContainer/Panel/HBoxContainer/TrackButton.pressed = true


func change_title(_final : String = "00:00:00") -> void:
	$Tween.interpolate_property($LinearTimeTrackingContainer/Panel/TimeTrack, 'percent_visible', 1.0, 0.0, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT, 0.0)
	$Tween.interpolate_property($LinearTimeTrackingContainer/Panel/TimeTrack, 'percent_visible', 0.0, 1.0, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT, 0.5)
	$Tween.start()
	yield(get_tree().create_timer(0.5), "timeout")
		
	$LinearTimeTrackingContainer/Panel/TimeTrack.text = _final


func update_total_time() -> void:
	var _time : Array = get_hours_minutes_seconds(total_secs)
	$LinearTimeTrackingContainer/Panel/Total.text = "total " + _time[2] + ":" + _time[1] + ":" + _time[0]


func remove_time_track(idx : int) -> void:
	total_secs -= res.tracks[idx].length
	res.tracks.erase(idx)
	update_total_time()


func update_time_track_item_text(_text : String, _id : int) -> void:
	res.tracks[_id].name = _text

func _on_TrackButton_toggled(button_pressed: bool) -> void:
	if cancel:
		cancel = false
		return
	if button_pressed:
		Defaults.time_tracking = true
		Defaults.item_tracked = $LinearTimeTrackingContainer/Panel/Label.text
		emit_signal("toggle_time_track", Defaults.item_tracked, true)
		$Timer.start()
		$SecondsTimer.start()
		change_title()
		$LinearTimeTrackingContainer/Panel/HBoxContainer/CancelButton.show()
		$LinearTimeTrackingContainer/Panel/HBoxContainer/PauseButton.show()
		$LinearTimeTrackingContainer/Panel/Label.editable = false
	else:
		Defaults.time_tracking = false
		emit_signal("toggle_time_track","", false)
		add_time_track(86400 - $Timer.time_left, $LinearTimeTrackingContainer/Panel/Label.text, OS.get_datetime())
		change_title("")
		$LinearTimeTrackingContainer/Panel/Label.editable = true
		$Timer.stop()
		$SecondsTimer.stop()
		$LinearTimeTrackingContainer/Panel/HBoxContainer/CancelButton.hide()
		$LinearTimeTrackingContainer/Panel/HBoxContainer/PauseButton.hide()
		save()

	


func _on_CancelButton_pressed() -> void:
	Defaults.time_tracking = false
	cancel = true
	change_title("")
	emit_signal("toggle_time_track", "", false)
	$LinearTimeTrackingContainer/Panel/HBoxContainer/TrackButton.pressed = false
	$LinearTimeTrackingContainer/Panel/Label.editable = true
	$Timer.stop()
	$SecondsTimer.stop()
	$LinearTimeTrackingContainer/Panel/HBoxContainer/CancelButton.hide()
	$LinearTimeTrackingContainer/Panel/HBoxContainer/PauseButton.hide()


func _on_PauseButton_toggled(button_pressed: bool) -> void:
	if button_pressed:
		$Timer.paused = true
		$SecondsTimer.paused = true
	else:
		$Timer.paused = false
		$SecondsTimer.paused = false
		
		
func _on_delete_pressed(idx : int) -> void:
	remove_time_track(idx)
	
	
func _time_track_item_pressed(_name : String) -> void:
	start_time_tracking_custom(_name)


func _on_new_time_track_item_text(_text : String, _idx : int) -> void:
	update_time_track_item_text(_text, _idx)


func _on_SecondsTimer_timeout() -> void:
	var _time : Array = get_hours_minutes_seconds(86400 - $Timer.time_left)
	$LinearTimeTrackingContainer/Panel/TimeTrack.text = _time[2] + ":" + _time[1] + ":" + _time[0]
	Defaults.time_tracked = _time[2] + ":" + _time[1] + ":" + _time[0]


func _on_PomodoroBtn_toggled(button_pressed: bool) -> void:
	$PomodoroContainer.visible = button_pressed
	$LinearTimeTrackingContainer.visible = !button_pressed
