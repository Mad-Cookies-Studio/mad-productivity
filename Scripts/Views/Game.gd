extends Control

export var title : String

var active : bool = false

func _ready() -> void:
	pass

func entering_view() -> void:
	Defaults.active_view_pointer = self
	Defaults.emit_signal("view_changed", title, false, false)
	active = true
	
	
func leaving_view() -> void:
	active = false
