extends Control

var active_view : int = -1
var active_view_name : String

enum VIEWS {DASH, NOTES, TIMETRACK, REMINDERS, TODO, PROFILE}

func _ready() -> void:
	if Defaults.settings_res.remember_last_session_view:
#		manual_view_toggle(Defaults.settings_res.last_session_view)
		manual_view_toggle(Defaults.settings_res.last_session_view)
	else:
		manual_view_toggle(0)

func toggle_view(new : int = -1, target : String = "") -> void:
	if new == active_view: return
	
	# hide the previous view if it's not directy after the start of the game
	# as -1 is the default one
	# also used for when we want to show nothing
	# which is probably never
	if active_view != -1 and active_view_name != "":
		$MainWorkspace/Views.get_node(active_view_name).hide()
		$MainWorkspace/Views.get_node(active_view_name).leaving_view()
		
	# show the new one.
	# selecting either by id or by name
	if target != "":
		print("activating view using the name")
		$MainWorkspace/Views.get_node(target).show()
		$MainWorkspace/Views.get_node(target).entering_view()
		active_view = $MainWorkspace/Views.get_node(target).get_position_in_parent()
	else:
		$MainWorkspace/Views.get_child(new).show()
		$MainWorkspace/Views.get_child(new).entering_view()
		active_view = $MainWorkspace/Views.get_child(new).get_position_in_parent()
		
	Defaults.active_view = active_view
	active_view_name = target


func manual_view_toggle(which : int) -> void:
	$MainWorkspace/Sidebar.manual_view_toggle(which)


func _on_Sidebar_view_changed(which : int, target : String) -> void:
	toggle_view(which, target)


func _on_Views_manual_view_toggle(which) -> void:
	manual_view_toggle(which)
