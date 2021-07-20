extends Control

signal toggle_time_track(_name, really)

export var title : String
var res : TimeTrackResource
var cancel : = false

var active_track : int

var total_secs : int

func _ready() -> void:
	res = load(Defaults.TIMETRACKS_SAVE_PATH + Defaults.TIMETRACKS_SAVE_NAME)
	_on_PomodoroBtn_toggled(res.pomodoro_on)
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
		create_track_visual(item.name, item.get_start_unix_time(), item.get_len(), i)
	
	
func create_track_visual(_name : String, _date : int, _time : int, _id : int) -> void:
	var new : ColorRect = $LinearTimeTrackingContainer/ScrollContainer/VBoxContainer/TrackedItem.duplicate()
	new.id = _id
	
	var time = get_hours_minutes_seconds(_time)
	new.connect("delete_pressed", self, "_on_delete_pressed")
	new.connect("time_track_item", self, "_time_track_item_pressed")
	new.connect("new_tracked_item_text", self, "_on_new_time_track_item_text")
	
	new.fill_details(Defaults.get_datetime_from_unix_time(_date), (time[2] + ":" + time[1] + ":" + time[0]), _name)

	new.show()
	$LinearTimeTrackingContainer/ScrollContainer/VBoxContainer.add_child(new)
	$LinearTimeTrackingContainer/ScrollContainer/VBoxContainer.move_child(new, 1)
	new.show_up()


func add_new_time_track(_name : String, _date : int) -> void:
	active_track = res.add_track(_date, _name)
	
	
func finish_time_track(_name : String, _date : int) -> void:
	var track : TimeTrackItem = res.get_track(active_track)
	track.end_interval(_date)
	total_secs += track.get_len(true)
	update_total_time()
	create_track_visual(_name, _date, track.get_len(), res.tracks.size())
	
	
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
		add_new_time_track($LinearTimeTrackingContainer/Panel/Label.text, OS.get_unix_time())
		$Timer.start()
		$SecondsTimer.start()
		change_title()
		$LinearTimeTrackingContainer/Panel/HBoxContainer/CancelButton.show()
		$LinearTimeTrackingContainer/Panel/HBoxContainer/PauseButton.show()
		$LinearTimeTrackingContainer/Panel/Label.editable = false
	else:
		Defaults.time_tracking = false
		emit_signal("toggle_time_track","", false)
		finish_time_track($LinearTimeTrackingContainer/Panel/Label.text, OS.get_unix_time())
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
		res.get_track(active_track).end_interval(OS.get_unix_time())
	else:
		$Timer.paused = false
		$SecondsTimer.paused = false
		res.get_track(active_track).resume(OS.get_unix_time())
		
		
func _on_delete_pressed(idx : int) -> void:
	remove_time_track(idx)
	
	
func _time_track_item_pressed(_name : String) -> void:
	start_time_tracking_custom(_name)


func _on_new_time_track_item_text(_text : String, _idx : int) -> void:
	update_time_track_item_text(_text, _idx)


func _on_SecondsTimer_timeout() -> void:
	var _time : Array = get_hours_minutes_seconds(86400 - $Timer.time_left)
	#if _time[1] >= Defaults.settings_res.pomo_work_time_length:
		#print("rest")
	$LinearTimeTrackingContainer/Panel/TimeTrack.text = _time[2] + ":" + _time[1] + ":" + _time[0]
	Defaults.time_tracked = _time[2] + ":" + _time[1] + ":" + _time[0]


func _on_PomodoroBtn_toggled(button_pressed: bool) -> void:
	$LinearTimeTrackingContainer/PomodoroPanel.visible = button_pressed
	$LinearTimeTrackingContainer/Panel.visible = !button_pressed
	res.pomodoro_on = button_pressed
