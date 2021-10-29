extends Resource
class_name ThemeResource

export(Color) var primary_col : Color
export(Color) var highlight_colour : Color
export(float) var contrast : float 

# Button specific

export var btn_active_col : Color
export var btn_inactive_col : Color

# Fonts
export(Color) var text_color


# private vars calculated based on the contrast value
var normal : Color
var darker : Color
var super_dark : Color
var lighter : Color
var highlight_lighter : Color
var highlight_darker : Color

func update_theme_values() -> void:
	# btn defaults
	btn_inactive_col = Color("6fffffff")
	btn_active_col = highlight_colour
	
	# maths!
	normal = primary_col
	darker = primary_col.linear_interpolate(Color.black, contrast)
	super_dark = primary_col.linear_interpolate(Color.black, contrast * 2.0)
	lighter = primary_col.linear_interpolate(Color.white, contrast)
	
	highlight_lighter = highlight_colour.linear_interpolate(Color.white, contrast)
	highlight_darker = highlight_colour.linear_interpolate(Color.black, contrast)


func get_color(which : int) -> Color:
	match which:
		0:
			# primary
			return primary_col
		1:
			# highlight
			return highlight_colour
		2:
			# text color
			return text_color
		_: 
			return primary_col

func set_color(which : int, new : Color) -> void:
	match which:
		0:
			# primary
			primary_col = new
		1:
			# highlight
			highlight_colour = new
		2:
			# text color
			text_color = new

	Defaults.update_theme()
#	Defaults.emit_signal("theme_changed")


func save_theme() -> void:
	ResourceSaver.save(Defaults.settings_res.THEME_SAVE_PATH, self)
