extends Control

var active_view : int = -1

func _ready() -> void:
	toggle_view(0)

func toggle_view(new : int) -> void:
	if new == active_view: return
	
	if active_view != -1:
		$MainWorkspace/Views.get_child(active_view).hide()
	$MainWorkspace/Views.get_child(new).show()
	active_view = new


func _on_Sidebar_view_changed(which) -> void:
	toggle_view(which)
