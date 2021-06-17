tool
extends EditorPlugin

const NODE_NAME = "CalendarButton"
const INHERITANCE = "TextureButton"
const CALENDAR_SCRIPT = preload("scripts/calendar_script.gd")
const CALENDAR_ICON = preload("icon.png")

func _enter_tree():
	add_custom_type(NODE_NAME, INHERITANCE, CALENDAR_SCRIPT, CALENDAR_ICON)

func _exit_tree():
	remove_custom_type(NODE_NAME)
