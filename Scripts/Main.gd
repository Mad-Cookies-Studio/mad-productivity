extends Control

var active_view : int = -1

enum VIEWS {DASH, NOTES, TIMETRACK, REMINDERS, TODO, PROFILE}

func _ready() -> void:
	manual_view_toggle(0)

func toggle_view(new : int) -> void:
	if new == active_view: return
	
	# hide the previous view if it's not directy after the start of the game
	# as -1 is the default one
	# also used for when we want to show nothing
	# which is probably never
	if active_view != -1:
		$MainWorkspace/Views.get_child(active_view).hide()
		$MainWorkspace/Views.get_child(active_view).leaving_view()
		
	# show the new one.
	$MainWorkspace/Views.get_child(new).show()
	$MainWorkspace/Views.get_child(new).entering_view()
	active_view = new


func manual_view_toggle(which : int) -> void:
	$MainWorkspace/Sidebar.manual_view_toggle(which)


func _on_Sidebar_view_changed(which) -> void:
	toggle_view(which)


func _on_Views_manual_view_toggle(which) -> void:
	manual_view_toggle(which)
