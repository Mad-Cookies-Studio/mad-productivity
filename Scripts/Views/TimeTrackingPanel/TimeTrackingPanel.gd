extends Panel

signal register_time_track_item(track_item)

export(Color) var pomodoro_color

enum STATES { NORMAL, POMODORO, POMODORO_BREAK }
enum TRACKING_STATE { IDLE, ACTIVE, PAUSED}
enum BUTTONS {START, CONTINUE, FINISH, BREAK, CANCEL, PAUSE, RESET}

const OPEN_SIZE : int = 250

var state : int = 0
var time_tracking : bool = false

var tracked_seconds : int = 0
var formatted_time : String = ""
var pomodoro_phase : = 0

# stats
var track_start : int
var track_end : int


# current time track item
var curr_track_item : TimeTrackItem


func _ready() -> void:
	Defaults.time_tracking_panel = self
	toggle_view(STATES.NORMAL)
	hookup_signals()
	update_pomo_number(false)
	check_unfinished_track()
	
	
func hookup_signals() -> void:
	# Pomodoro
	$Content/VBoxContainer/PomodoroButtons/PomodoroStart.connect("charged",self, "on_pom_charged", [BUTTONS.START])
	$Content/VBoxContainer/PomodoroButtons/PomodoroContinue.connect("charged",self, "on_pom_charged", [BUTTONS.CONTINUE])
	$Content/VBoxContainer/PomodoroButtons/PomodoroFinish.connect("charged",self, "on_pom_charged", [BUTTONS.FINISH])
	$Content/VBoxContainer/PomodoroButtons/PomodoroBreak.connect("charged",self, "on_pom_charged", [BUTTONS.BREAK])
	$Content/VBoxContainer/PomodoroButtons/PomodoroCancel.connect("charged",self, "on_pom_charged", [BUTTONS.CANCEL])
	$Content/VBoxContainer/PomodoroButtons/PomodoroReset.connect("charged",self, "on_pom_charged", [BUTTONS.RESET])
	# Normal
	$Content/VBoxContainer/NormalButtons/NormalStart.connect("charged",self, "on_normal_charged", [BUTTONS.START])
	$Content/VBoxContainer/NormalButtons/NormalPause.connect("charged",self, "on_normal_charged", [BUTTONS.PAUSE])
	$Content/VBoxContainer/NormalButtons/NormalContinue.connect("charged",self, "on_normal_charged", [BUTTONS.CONTINUE])
	$Content/VBoxContainer/NormalButtons/NormalFinish.connect("charged",self, "on_normal_charged", [BUTTONS.FINISH])
	$Content/VBoxContainer/NormalButtons/NormalCancel.connect("charged",self, "on_normal_charged", [BUTTONS.CANCEL])
	# others perhaps?


func check_unfinished_track() -> void:
	if Defaults.settings_res.unsaved_time_track:
		
		
		curr_track_item = Defaults.settings_res.unsaved_time_track
		print(curr_track_item.type)
		if curr_track_item.type == STATES.NORMAL:
			$Content/StateButtons/Normal.pressed = true
			_on_Normal_pressed()
		else:
			$Content/StateButtons/Pomodoro.pressed = true
			_on_Pomodoro_pressed()
			
		$Content/StateButtons/Pomodoro.disabled = true
		$Content/StateButtons/Normal.disabled = true
		
		
		tracked_seconds = curr_track_item.get_duration()
		update_time()
		
		$Content/VBoxContainer/ItemInput.text = curr_track_item.name
		$Content/VBoxContainer/Time/ItemLabel.text = curr_track_item.name
		
		continue_time_tracking()
	
	

func toggle_self(really : bool) -> void:
	update_pomo_number(false)
	$Tween.remove_all()
	var fin_size : int
	fin_size = OPEN_SIZE if really else 0
	var fin_opacity : float = 1.0 if really else 0.0
	$Tween.interpolate_property(self, "rect_min_size:x", rect_min_size.x, fin_size, 0.6, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.0)
	$Tween.interpolate_property($Content, "modulate:a", $Content.modulate.a, fin_opacity, 0.6, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.0)
	$Tween.start()


func toggle_view(which : int) -> void:
	match which:
		STATES.NORMAL: # Normal
			state = STATES.NORMAL
			$Content/VBoxContainer/PomodoroButtons.hide()
			$Content/VBoxContainer/NormalButtons.show()
			$Content/VBoxContainer/Time/PomodoroProgress.hide()
			$Content/VBoxContainer/Time.self_modulate = Defaults.ui_theme.text_color
			$Content/VBoxContainer/Time/PomodoroCount.hide()
		_: # Pomodoro
			state = STATES.POMODORO
			$Content/VBoxContainer/Time/PomodoroProgress.show()
			$Content/VBoxContainer/PomodoroButtons.show()
			$Content/VBoxContainer/Time/PomodoroCount.show()
			$Content/VBoxContainer/NormalButtons.hide()
			$Content/VBoxContainer/Time.self_modulate = pomodoro_color
			update_pomo_number()
	update_time()
	reset_buttons()


func start_time_tracking() -> void:
	time_tracking = true
	$Content/StateButtons/Normal.disabled = true
	$Content/StateButtons/Pomodoro.disabled = true
	$SecondsTimer.start()
	
	curr_track_item = TimeTrackItem.new()
	curr_track_item.create_track($Content/VBoxContainer/ItemInput.text)
	curr_track_item.start_tracking(OS.get_unix_time())
	curr_track_item.type = state
	
	$ProgressTween.remove_all()
	
	match state:
		STATES.NORMAL:
			$Content/VBoxContainer/NormalButtons/NormalStart.hide()
			$Content/VBoxContainer/NormalButtons/NormalContinue.hide()
			$Content/VBoxContainer/NormalButtons/NormalPause.show()
			$Content/VBoxContainer/NormalButtons/NormalFinish.show()
			$Content/VBoxContainer/NormalButtons/NormalCancel.show()
		STATES.POMODORO:
			$Content/VBoxContainer/PomodoroButtons/PomodoroStart.hide()
			$Content/VBoxContainer/PomodoroButtons/PomodoroReset.hide()
			$Content/VBoxContainer/PomodoroButtons/PomodoroContinue.show()
			$Content/VBoxContainer/PomodoroButtons/PomodoroFinish.show()
			$Content/VBoxContainer/PomodoroButtons/PomodoroBreak.show()
			$Content/VBoxContainer/PomodoroButtons/PomodoroCancel.show()
			set_up_pomo_progress_bar()
		STATES.POMODORO_BREAK:
			$Content/VBoxContainer/PomodoroButtons/PomodoroStart.hide()
			$Content/VBoxContainer/PomodoroButtons/PomodoroReset.hide()
			$Content/VBoxContainer/PomodoroButtons/PomodoroContinue.show()
			$Content/VBoxContainer/PomodoroButtons/PomodoroFinish.show()
			$Content/VBoxContainer/PomodoroButtons/PomodoroCancel.show()
			$Content/VBoxContainer/PomodoroButtons/PomodoroBreak.hide()
			set_up_pomo_progress_bar()


func start_pomodoro_break() -> void:
	if state != STATES.POMODORO:
		return
	state = STATES.POMODORO_BREAK
	reset_time()
	$Content/VBoxContainer/Time/BreakLabel.show()
	start_time_tracking()
	

func stop_time_tracking(cancel : bool ) -> void:
	if !cancel and state != STATES.POMODORO_BREAK:
		# wrap up the time track officialy and send it off
		curr_track_item.end_tracking(OS.get_unix_time())
		curr_track_item.type = state
		emit_signal("register_time_track_item", curr_track_item)
		print(tracked_seconds)
		print(curr_track_item.get_duration())
		curr_track_item = null
		print("sending a signal of a completed time track to be added to the database - TODO")
		print("name, seconds tracked, state")
		print($Content/VBoxContainer/ItemInput.text,", " , tracked_seconds, ", ", state)
		if state == STATES.POMODORO_BREAK:
			update_pomo_number(!cancel)
		
	
	# take care of the state and buttons
	time_tracking = false
	$SecondsTimer.stop()
	$Content/StateButtons/Normal.disabled = false
	$Content/StateButtons/Pomodoro.disabled = false
	$Content/VBoxContainer/Time/PomodoroProgress.value = 0
	
	Defaults.settings_res.unsaved_time_track = null
	# reset vars
	reset_time()
	
	if cancel and state == STATES.POMODORO_BREAK:
		state = STATES.POMODORO
		$Content/VBoxContainer/Time/BreakLabel.hide()
	
	# functions
	update_time()
	reset_buttons()


func pause_time_tracking() -> void:
	$SecondsTimer.paused = true
	#normal
	$Content/VBoxContainer/NormalButtons/NormalStart.hide()
	$Content/VBoxContainer/NormalButtons/NormalPause.hide()
	$Content/VBoxContainer/NormalButtons/NormalContinue.show()
	#pomdoro


func continue_time_tracking() -> void:
	time_tracking = true
	if !$SecondsTimer.paused:
		$SecondsTimer.start()
	$SecondsTimer.paused = false
	#normal
	$Content/VBoxContainer/NormalButtons/NormalStart.hide()
	$Content/VBoxContainer/NormalButtons/NormalPause.show()
	$Content/VBoxContainer/NormalButtons/NormalContinue.hide()
	$Content/VBoxContainer/NormalButtons/NormalFinish.show()
	$Content/VBoxContainer/NormalButtons/NormalCancel.show()
	#pomodoro
	$Content/VBoxContainer/PomodoroButtons/PomodoroStart.hide()
	$Content/VBoxContainer/PomodoroButtons/PomodoroContinue.hide()
	$Content/VBoxContainer/PomodoroButtons/PomodoroBreak.show()
	$Content/VBoxContainer/PomodoroButtons/PomodoroFinish.show()
	$Content/VBoxContainer/PomodoroButtons/PomodoroCancel.show()
	
	match state:
		STATES.POMODORO_BREAK:
			update_pomo_number(true)
			stop_time_tracking(true)
			state = STATES.POMODORO
			start_time_tracking()
			$Content/VBoxContainer/Time/BreakLabel.hide()

func update_time() -> void:
	match state :
		STATES.NORMAL:
			formatted_time = Defaults.get_formatted_time_from_seconds(tracked_seconds)
		STATES.POMODORO:
			formatted_time = Defaults.get_formatted_time_from_seconds(Defaults.settings_res.pomo_work_time_length - tracked_seconds)
		STATES.POMODORO_BREAK:
			if get_pomodoro_phase_simple() != Defaults.settings_res.pomo_long_pause_freq:
				formatted_time = Defaults.get_formatted_time_from_seconds(Defaults.settings_res.pomo_short_pause_length - tracked_seconds)
			else:
				formatted_time = Defaults.get_formatted_time_from_seconds(Defaults.settings_res.pomo_long_pause_length - tracked_seconds)
		
	if formatted_time.begins_with("00:"):
		formatted_time = formatted_time.trim_prefix("00:")
	$Content/VBoxContainer/Time.text = formatted_time


func update_pomo_number(increase : bool = false) -> void:
	pomodoro_phase = (pomodoro_phase + int(increase)) % (Defaults.settings_res.pomo_long_pause_freq + 1)
	$Content/VBoxContainer/Time/PomodoroCount.text = str(pomodoro_phase) + "/" + str(Defaults.settings_res.pomo_long_pause_freq)


func reset_buttons() -> void:
	for i in $Content/VBoxContainer/NormalButtons.get_children():
		i.hide()
	$Content/VBoxContainer/NormalButtons/NormalStart.show()
	for i in $Content/VBoxContainer/PomodoroButtons.get_children():
		i.hide()
	$Content/VBoxContainer/PomodoroButtons/PomodoroStart.show()
	$Content/VBoxContainer/PomodoroButtons/PomodoroReset.show()


func set_up_pomo_progress_bar() -> void:
	match state:
		STATES.POMODORO:
			$Content/VBoxContainer/Time/PomodoroProgress.max_value = Defaults.settings_res.pomo_work_time_length
		STATES.POMODORO_BREAK:
			if get_pomodoro_phase_simple() == Defaults.settings_res.pomo_long_pause_freq:
				$Content/VBoxContainer/Time/PomodoroProgress.max_value = Defaults.settings_res.pomo_long_pause_length
			else:
				$Content/VBoxContainer/Time/PomodoroProgress.max_value = Defaults.settings_res.pomo_short_pause_length
				
	$Content/VBoxContainer/Time/PomodoroProgress.value = $Content/VBoxContainer/Time/PomodoroProgress.max_value


func get_pomodoro_phase_simple() -> int:
	return pomodoro_phase % (Defaults.settings_res.pomo_long_pause_freq + 1)


func reset_time() -> void:
	tracked_seconds = 0
	$ProgressTween.remove_all()
	$Content/VBoxContainer/Time.text = "00:00"
	$Content/VBoxContainer/Time/PomodoroProgress.value = $Content/VBoxContainer/Time/PomodoroProgress.max_value


func quit() -> void:
	if time_tracking:
		Defaults.settings_res.unsaved_time_track = curr_track_item


## Signals
# -----------------------
func _on_TopArea_toggle_time_tracking_bar(really : bool) -> void:
	toggle_self(really)


func _on_Normal_pressed() -> void:
	toggle_view(STATES.NORMAL)


func _on_Pomodoro_pressed() -> void:
	toggle_view(STATES.POMODORO)


func on_pom_charged(which : int) -> void:
	match which:
		BUTTONS.BREAK:
			start_pomodoro_break()
		BUTTONS.CANCEL:
			stop_time_tracking(true)
		BUTTONS.CONTINUE:
			continue_time_tracking()
		BUTTONS.FINISH:
			stop_time_tracking(false)
		BUTTONS.START:
			start_time_tracking()
		BUTTONS.RESET:
			pomodoro_phase = 0
			

func on_normal_charged(which : int) -> void:
	match which:
		BUTTONS.PAUSE:
			pause_time_tracking()
		BUTTONS.CANCEL:
			stop_time_tracking(true)
		BUTTONS.CONTINUE:
			continue_time_tracking()
		BUTTONS.FINISH:
			stop_time_tracking(false)
		BUTTONS.START:
			start_time_tracking()


func _on_SecondsTimer_timeout() -> void:
	if !time_tracking:
		$SecondsTimer.stop()
		return
	tracked_seconds += 1
	update_time()
	
#	$Content/VBoxContainer/Time/PomodoroProgress.value = $Content/VBoxContainer/Time/PomodoroProgress.max_value - tracked_seconds
	$ProgressTween.interpolate_property($Content/VBoxContainer/Time/PomodoroProgress, "value", $Content/VBoxContainer/Time/PomodoroProgress.value, $Content/VBoxContainer/Time/PomodoroProgress.max_value - tracked_seconds, 1.0, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.0)
	$ProgressTween.start()
	
	
	if state == STATES.POMODORO and tracked_seconds >= Defaults.settings_res.pomo_work_time_length:
		stop_time_tracking(false)
		start_pomodoro_break()
	
	if state == STATES.POMODORO_BREAK:
		if get_pomodoro_phase_simple() == Defaults.settings_res.pomo_long_pause_freq and tracked_seconds >= Defaults.settings_res.pomo_long_pause_length:
			pass # TODO what happends when the break is over
		if get_pomodoro_phase_simple() != Defaults.settings_res.pomo_long_pause_freq and tracked_seconds >= Defaults.settings_res.pomo_short_pause_length:
			pass # TODO what happends when the break is over
	


func _on_ItemInput_text_changed(new_text: String) -> void:
	$Content/VBoxContainer/Time/ItemLabel.text = new_text
	if curr_track_item:
		curr_track_item.name = new_text
