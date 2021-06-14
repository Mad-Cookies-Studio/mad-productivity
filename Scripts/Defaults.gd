extends Node

const DAYS : Array = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
const MONTHS : Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

export(Color) var btn_active_colour : Color
export(Color) var btn_inactive_colour : Color


func quit() -> void:
	get_tree().quit()
