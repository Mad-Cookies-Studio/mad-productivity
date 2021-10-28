extends Control

signal toggle_time_track(_name, really)

export var title : String
var res : TimeTrackResource
var cancel : = false

var active_track : int

var total_secs : int

var pomodoro_count : int
var notified : bool
var is_resting : bool
var rest_time : int
var rest_len : int

func _ready() -> void:
	if res == null:
		load_res()
	load_time_tracks()
	update_total_time()


func load_res() -> void:
	res = load(Defaults.TIMETRACKS_SAVE_PATH + Defaults.TIMETRACKS_SAVE_NAME)


func entering_view() -> void:
	Defaults.active_view_pointer = self
	Defaults.emit_signal("view_changed", title, true, false)
	
	
func leaving_view() -> void:
	save()
	
	
func load_time_tracks() -> void:
	var unfinished_track : bool = false
	for i in res.tracks:
		var item = res.tracks[i]
		if item.is_finished():
			create_track_visual(item.name, item.get_start_unix_time(), item.get_len(), i)
		elif !unfinished_track:
			active_track = i
			$LinearTimeTrackingContainer/Panel/Label.text = item.name
			$LinearTimeTrackingContainer/Panel/HBoxContainer/TrackButton.pressed = true
			start_tracking(item)
			unfinished_track = true
		else:
			# TODO: error handling
			print("there shoudn't be more than one unfinished task")
	$LinearTimeTrackingContainer/Panel/HBoxContainer/TrackButton.connect("toggled", self, "_on_TrackButton_toggled")
	
	
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
	
	
func finish_time_track(_name : String, _date : int) -> void:
	var track : TimeTrackItem = res.get_track(active_track)
	track.end_tracking(_date)
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
		active_track = res.add_track($LinearTimeTrackingContainer/Panel/Label.text)
		res.get_track(active_track).start_tracking(OS.get_unix_time())
		start_tracking(res.get_track(active_track))
		is_resting = false
		notified = false
		pomodoro_count += 1
		$LinearTimeTrackingContainer/Panel/PomodoroContainer/PomodoroCount.visible = true
		$LinearTimeTrackingContainer/Panel/PomodoroContainer/PomodoroCount.text = str(pomodoro_count) + "/" + str(Defaults.settings_res.pomo_long_pause_freq)
		$LinearTimeTrackingContainer/Panel/HBoxContainer/BreakButton.hide()
		save()
	else:
		Defaults.time_tracking = false
		emit_signal("toggle_time_track","", false)
		finish_time_track($LinearTimeTrackingContainer/Panel/Label.text, OS.get_unix_time())
		change_title("")
		$LinearTimeTrackingContainer/Panel/Label.editable = true
		$SecondsTimer.stop()
		$LinearTimeTrackingContainer/Panel/HBoxContainer/CancelButton.hide()
		$LinearTimeTrackingContainer/Panel/HBoxContainer/PauseButton.hide()
		save()

func start_tracking(_track : TimeTrackItem) -> void:
	Defaults.time_tracking = true
	Defaults.item_tracked = _track.name
	emit_signal("toggle_time_track", Defaults.item_tracked, true)
	$SecondsTimer.start()
	change_title()
	$LinearTimeTrackingContainer/Panel/HBoxContainer/CancelButton.show()
	$LinearTimeTrackingContainer/Panel/HBoxContainer/PauseButton.show()
	$LinearTimeTrackingContainer/Panel/Label.editable = false

func _on_CancelButton_pressed() -> void:
	Defaults.time_tracking = false
	cancel = true
	change_title("")
	emit_signal("toggle_time_track", "", false)
	$LinearTimeTrackingContainer/Panel/HBoxContainer/TrackButton.pressed = false
	$LinearTimeTrackingContainer/Panel/Label.editable = true
	$SecondsTimer.stop()
	$LinearTimeTrackingContainer/Panel/HBoxContainer/CancelButton.hide()
	$LinearTimeTrackingContainer/Panel/HBoxContainer/PauseButton.hide()


func _on_PauseButton_toggled(button_pressed: bool) -> void:
	if button_pressed:
		$SecondsTimer.paused = true
		res.get_track(active_track).end_tracking(OS.get_unix_time())
	else:
		$SecondsTimer.paused = false
		res.get_track(active_track).start_tracking(OS.get_unix_time())
		
		
func _on_delete_pressed(idx : int) -> void:
	remove_time_track(idx)
	
	
func _time_track_item_pressed(_name : String) -> void:
	start_time_tracking_custom(_name)


func _on_new_time_track_item_text(_text : String, _idx : int) -> void:
	update_time_track_item_text(_text, _idx)


func update_rest_time():
	$PauseOverlay/VBX/TimeLbl.text = Defaults.get_formatted_time_from_seconds(rest_len)

func _on_SecondsTimer_timeout() -> void:
	var _time : Array = get_hours_minutes_seconds(res.get_track(active_track).get_duration())
	if res.pomodoro_on:
		# end of the pomodoro
		if !is_resting && int(_time[0]) >= Defaults.settings_res.pomo_work_time_length * 60:
			$LinearTimeTrackingContainer/Panel/HBoxContainer/BreakButton.show()
			# start break break button text set is here
			$LinearTimeTrackingContainer/Panel/HBoxContainer/BreakButton.text = "Break"
			if !notified:
				$AudioPlayer.playing = true
				notified = true
	$LinearTimeTrackingContainer/Panel/TimeTrack.text = _time[2] + ":" + _time[1] + ":" + _time[0]
	Defaults.time_tracked = _time[2] + ":" + _time[1] + ":" + _time[0]


func _on_RestTimer_timeout():
	rest_len += 1
	update_rest_time()
	if rest_len >= rest_time:
		if !notified:
			$AudioPlayer.playing = true
			notified = true


func _on_BreakButton_pressed():
	$LinearTimeTrackingContainer/Panel/HBoxContainer/TrackButton.pressed = false
	is_resting = true
	notified = false
	if pomodoro_count >= Defaults.settings_res.pomo_long_pause_freq:
		pomodoro_count = 0
		rest_time = Defaults.settings_res.pomo_long_pause_length * 60
	else:
		rest_time = Defaults.settings_res.pomo_short_pause_length * 60
	rest_len = 0
	$RestTimer.start()
	$LinearTimeTrackingContainer/Panel/HBoxContainer/BreakButton.hide()
	$PauseOverlay.show()
	update_rest_time()
		


func _on_PomodoroBtn_toggled(button_pressed: bool) -> void:
	$LinearTimeTrackingContainer/Panel/PomodoroContainer.visible = button_pressed
	
	if res == null:
		load_res()
	res.pomodoro_on = button_pressed


func _on_ContinueBreakBtn_pressed() -> void:
	$LinearTimeTrackingContainer/Panel/HBoxContainer/TrackButton.pressed = true
	$RestTimer.stop()
	$PauseOverlay.hide()
	

func _on_FinishBtn_pressed() -> void:
	$RestTimer.stop()
	$PauseOverlay.hide()
	$LinearTimeTrackingContainer/Panel/HBoxContainer/TrackButton.pressed = false
	_on_TrackButton_toggled(false)
