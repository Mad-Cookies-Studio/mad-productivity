extends Panel

export(Color) var pomodoro_color

enum STATES { NORMAL, POMODORO }

const OPEN_SIZE : int = 250

var state : int = 0

func _ready() -> void:
	toggle_view(STATES.NORMAL)


func toggle_self(really : bool) -> void:
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
		STATES.POMODORO: # Pomodoro
			state = STATES.POMODORO
			$Content/VBoxContainer/Time/PomodoroProgress.show()
			$Content/VBoxContainer/PomodoroButtons.show()
			$Content/VBoxContainer/NormalButtons.hide()
			$Content/VBoxContainer/Time.self_modulate = pomodoro_color


## Signals
# -----------------------
func _on_TopArea_toggle_time_tracking_bar(really : bool) -> void:
	toggle_self(really)


func _on_Normal_pressed() -> void:
	toggle_view(STATES.NORMAL)


func _on_Pomodoro_pressed() -> void:
	toggle_view(STATES.POMODORO)
