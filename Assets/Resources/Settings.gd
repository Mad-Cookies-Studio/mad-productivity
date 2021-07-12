class_name SettingsResource
extends Resource

export(String) var name = "Name"
export(String) var title = "User title"
export(bool) var particles
export(bool) var always_on_top
export(float) var drag_sensitivity

# window save
export var remember_window_settings : bool = true
export var window_size : Vector2 = Vector2(1100, 650)
export var window_pos : Vector2 = Vector2.ZERO
