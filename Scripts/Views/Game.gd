extends Control

export var title : String

var active : bool = false

func _ready() -> void:
	pass

func entering_view() -> void:
	Defaults.active_view_pointer = self
	Defaults.emit_signal("view_changed", title, false, false)
	active = true
	update_view_text()
	
	
func leaving_view() -> void:
	active = false


func update_view_text() -> void:
	var text : String = ""
	Defaults.emit_signal("update_view_info", text)
	
	
## SIGNALS
