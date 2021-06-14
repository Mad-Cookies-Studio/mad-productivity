extends Control

var active_view : int = -1

func _ready() -> void:
	# show the first view when ready
	toggle_view(0)

func toggle_view(new : int) -> void:
	if new == active_view: return
	
	# hide the previous view if it's not directy after the start of the game
	# as -1 is the default one
	# also used for when we want to show nothing
	# which is probably never
	if active_view != -1:
		$MainWorkspace/Views.get_child(active_view).hide()
		
	# show the new one.
	$MainWorkspace/Views.get_child(new).show()
	active_view = new


func _on_Sidebar_view_changed(which) -> void:
	toggle_view(which)
