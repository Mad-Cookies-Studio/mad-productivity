extends Panel

signal register_time_track_item(_name, _length, _state)

export(Color) var pomodoro_color

enum STATES { NORMAL, POMODORO, POMODORO_BREAK }
enum TRACKING_STATE { IDLE, ACTIVE, PAUSED}
enum BUTTONS {START, CONTINUE, FINISH, BREAK, CANCEL, PAUSE}

const OPEN_SIZE : int = 250

var state : int = 0
var time_tracking : bool = false

var tracked_seconds : int = 0
var formatted_time : String = ""
var pomodoro_phase : = 0

func _ready() -> void:
	toggle_view(STATES.NORMAL)
	hookup_signals()
	update_pomo_number(false)
	
	
func hookup_signals() -> void:
	# Pomodoro
	$Content/VBoxContainer/PomodoroButtons/PomodoroStart.connect("charged",self, "on_pom_charged", [BUTTONS.START])
	$Content/VBoxContainer/PomodoroButtons/PomodoroContinue.connect("charged",self, "on_pom_charged", [BUTTONS.CONTINUE])
	$Content/VBoxContainer/PomodoroButtons/PomodoroFinish.connect("charged",self, "on_pom_charged", [BUTTONS.FINISH])
	$Content/VBoxContainer/PomodoroButtons/PomodoroBreak.connect("charged",self, "on_pom_charged", [BUTTONS.BREAK])
	$Content/VBoxContainer/PomodoroButtons/PomodoroCancel.connect("charged",self, "on_pom_charged", [BUTTONS.CANCEL])
	# Normal
	$Content/VBoxContainer/NormalButtons/NormalStart.connect("charged",self, "on_normal_charged", [BUTTONS.START])
	$Content/VBoxContainer/NormalButtons/NormalPause.connect("charged",self, "on_normal_charged", [BUTTONS.PAUSE])
	$Content/VBoxContainer/NormalButtons/NormalContinue.connect("charged",self, "on_normal_charged", [BUTTONS.CONTINUE])
	$Content/VBoxContainer/NormalButtons/NormalFinish.connect("charged",self, "on_normal_charged", [BUTTONS.FINISH])
	$Content/VBoxContainer/NormalButtons/NormalCancel.connect("charged",self, "on_normal_charged", [BUTTONS.CANCEL])
	# others perhaps?


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
		STATES.POMODORO: # Pomodoro
			state = STATES.POMODORO
			$Content/VBoxContainer/Time/PomodoroProgress.show()
			$Content/VBoxContainer/PomodoroButtons.show()
			$Content/VBoxContainer/Time/PomodoroCount.show()
			$Content/VBoxContainer/NormalButtons.hide()
			$Content/VBoxContainer/Time.self_modulate = pomodoro_color


func start_time_tracking() -> void:
	time_tracking = true
	$Content/StateButtons/Normal.disabled = true
	$Content/StateButtons/Pomodoro.disabled = true
	$SecondsTimer.start()
	match state:
		STATES.NORMAL:
			$Content/VBoxContainer/NormalButtons/NormalStart.hide()
			$Content/VBoxContainer/NormalButtons/NormalPause.show()
			$Content/VBoxContainer/NormalButtons/NormalFinish.show()
			$Content/VBoxContainer/NormalButtons/NormalCancel.show()
		STATES.POMODORO:
			$Content/VBoxContainer/PomodoroButtons/PomodoroStart.hide()
			$Content/VBoxContainer/PomodoroButtons/PomodoroFinish.show()
			$Content/VBoxContainer/PomodoroButtons/PomodoroBreak.show()
			$Content/VBoxContainer/PomodoroButtons/PomodoroCancel.show()
			set_up_pomo_progress_bar()
		STATES.POMODORO_BREAK:
			$Content/VBoxContainer/PomodoroButtons/PomodoroStart.hide()
			$Content/VBoxContainer/PomodoroButtons/PomodoroContinue.show()
			$Content/VBoxContainer/PomodoroButtons/PomodoroFinish.show()
			$Content/VBoxContainer/PomodoroButtons/PomodoroCancel.show()
			$Content/VBoxContainer/PomodoroButtons/PomodoroBreak.hide()
			set_up_pomo_progress_bar()


func start_pomodoro_break() -> void:
	if state != STATES.POMODORO:
		return
	state = STATES.POMODORO_BREAK
	start_time_tracking()
	

func stop_time_tracking(cancel : bool ) -> void:
	# we send out a signal to register the item first
	emit_signal("register_time_track_item", $Content/VBoxContainer/ItemInput.text, tracked_seconds, state)
	
	# take care of the state and buttons
	time_tracking = false
	$SecondsTimer.stop()
	$Content/StateButtons/Normal.disabled = false
	$Content/StateButtons/Pomodoro.disabled = false
	$Content/VBoxContainer/Time/PomodoroProgress.value = 0
	# reset vars
	tracked_seconds = 0
	formatted_time = "00:00:00"
	
	if cancel and state == STATES.POMODORO_BREAK:
		state = STATES.POMODORO
	
	# functions
	update_time()
	update_pomo_number(!cancel)
	reset_buttons()


func pause_time_tracking() -> void:
	$SecondsTimer.paused = true
	#normal
	$Content/VBoxContainer/NormalButtons/NormalPause.hide()
	$Content/VBoxContainer/NormalButtons/NormalContinue.show()
	#pomdoro


func continue_time_tracking() -> void:
	$SecondsTimer.paused = false
	#normal
	$Content/VBoxContainer/NormalButtons/NormalPause.show()
	$Content/VBoxContainer/NormalButtons/NormalContinue.hide()
	#pomodoro
	$Content/VBoxContainer/PomodoroButtons/PomodoroContinue.hide()
	$Content/VBoxContainer/PomodoroButtons/PomodoroBreak.show()
	
	match state:
		STATES.POMODORO_BREAK:
			stop_time_tracking(true)
			state = STATES.POMODORO
			start_time_tracking()

func update_time() -> void:
	match state :
		STATES.POMODORO:
			formatted_time = Defaults.get_formatted_time_from_seconds(Defaults.settings_res.pomo_work_time_length - tracked_seconds)
		STATES.POMODORO_BREAK:
			formatted_time = Defaults.get_formatted_time_from_seconds(Defaults.settings_res.pomo_short_pause_length - tracked_seconds)
	if formatted_time.begins_with("00:"):
		formatted_time = formatted_time.trim_prefix("00:")
	$Content/VBoxContainer/Time.text = formatted_time


func update_pomo_number(increase : bool) -> void:
	pomodoro_phase += int(increase)
	$Content/VBoxContainer/Time/PomodoroCount.text = str(pomodoro_phase) + "/" + str(Defaults.settings_res.pomo_long_pause_freq)


func reset_buttons() -> void:
	for i in $Content/VBoxContainer/NormalButtons.get_children():
		i.hide()
	$Content/VBoxContainer/NormalButtons/NormalStart.show()
	for i in $Content/VBoxContainer/PomodoroButtons.get_children():
		i.hide()
	$Content/VBoxContainer/PomodoroButtons/PomodoroStart.show()


func set_up_pomo_progress_bar() -> void:
	match state:
		STATES.POMODORO:
			$Content/VBoxContainer/Time/PomodoroProgress.max_value = Defaults.settings_res.pomo_work_time_length
		STATES.POMODORO_BREAK:
			$Content/VBoxContainer/Time/PomodoroProgress.max_value = Defaults.settings_res.pomo_short_pause_length
	$Content/VBoxContainer/Time/PomodoroProgress.value = $Content/VBoxContainer/Time/PomodoroProgress.max_value


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
			print("break pom")
		BUTTONS.CANCEL:
			stop_time_tracking(true)
		BUTTONS.CONTINUE:
			continue_time_tracking()
		BUTTONS.FINISH:
			stop_time_tracking(false)
		BUTTONS.START:
			start_time_tracking()
			

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
	
	$Content/VBoxContainer/Time/PomodoroProgress.value = $Content/VBoxContainer/Time/PomodoroProgress.max_value - tracked_seconds
	
	if state == STATES.POMODORO and tracked_seconds >= Defaults.settings_res.pomo_work_time_length:
		stop_time_tracking(false)
		start_pomodoro_break()
	
	if state == STATES.POMODORO_BREAK and tracked_seconds >= Defaults.settings_res.pomo_short_pause_length:
		pass
	


func _on_ItemInput_text_changed(new_text: String) -> void:
	$Content/VBoxContainer/Time/ItemLabel.text = new_text
