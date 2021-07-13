extends Resource
class_name ThemeResource

export var primary_col : Color
export var secondary_col : Color
export var tertiary_col : Color
export var highlight_col : Color
export var highlight_text_col : Color
export var text_on_light_col : Color
export var text_on_dark_col : Color
export var title_text_col : Color

# Button specific

export var btn_active_col : Color
export var btn_inactive_col : Color


func trigger_theme_update() -> void:
	# TODO: Implement necessary methods to get all UI components to update their UI theme.
	# IDEA: Create a child node object that holds a UI theme update script
	# Add the child to each object which may need to be upated 
	# The object is also part of UI_THEME node group
	# This function calls the function
	## example of it is already written in Defaults.gd
	pass
