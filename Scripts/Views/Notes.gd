extends Control


var active_note : NoteResource
var active_btn : Button

var resource_file_paths : Array

func _ready() -> void:
	reset_state()
	$VBoxContainer/Control/AddBtn.connect("button_up", self, "_on_click_add_button")
	load_notes()
	
func load_notes() -> void:
	var dir : Directory = Directory.new()

	if dir.open(Defaults.NOTES_SAVE_PATH) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			else:
				resource_file_paths.append(file_name)
			file_name = dir.get_next()
			
	resource_file_paths.sort()
	for i in resource_file_paths:
		add_button_from_resource(load(Defaults.NOTES_SAVE_PATH + i))
	
#	if resource_file_paths.size() > 0:
#		select_note(1)
	
	
func select_note(which : int) -> void:
	var button : Button = $VBoxContainer/HSplitContainer/Panel/ScrollContainer/NoteButtons.get_child(which)
	button.pressed = true
	_on_note_btn_clicked(button.res, button)
	
	
	
func entering_view() -> void:
	pass
	
	
func leaving_view() -> void:
	save()
	
func save() -> void:
	Defaults.save_note_resource(active_note)
	
	
	
func add_button() -> void:
	var new_btn : Button = $VBoxContainer/HSplitContainer/Panel/ScrollContainer/NoteButtons/DefaultButton.duplicate()
	new_btn.visible = true
	var res : NoteResource = NoteResource.new()
	res.title = "New note"
	res.text = "Put text here"
	res.date_created = OS.get_datetime()
	res.date_modified = OS.get_datetime()
	res.save_name = Defaults.get_date_and_time_with_underscores({}) + "_Note" + str(randi() % 256)
	new_btn.res = res
	new_btn.text = res.title
	active_note = res
	
	new_btn.connect("button_down", self, "_on_note_btn_clicked", [res, new_btn])
#	new_btn.connect("note_delete_pressed", self, "_on_note_btn_delete_clicked")
	$VBoxContainer/HSplitContainer/Panel/ScrollContainer/NoteButtons.add_child(new_btn)
	new_btn.grab_click_focus()


func reset_state() -> void:
	$VBoxContainer/HSplitContainer/Panel2/VBoxContainer/Title.text = ""
	$VBoxContainer/HSplitContainer/Panel2/VBoxContainer/Note.text = ""
	active_note = null
	active_btn = null


func add_button_from_resource(res : NoteResource) -> void:
	var new_btn : Button = $VBoxContainer/HSplitContainer/Panel/ScrollContainer/NoteButtons/DefaultButton.duplicate()
	new_btn.visible = true
	res.date_modified = OS.get_datetime()
	new_btn.res = res
	new_btn.text = res.title
	active_note = res
	
	new_btn.connect("button_down", self, "_on_note_btn_clicked", [res, new_btn])
#	new_btn.connect("note_delete_pressed", self, "_on_note_btn_delete_clicked")
	$VBoxContainer/HSplitContainer/Panel/ScrollContainer/NoteButtons.add_child(new_btn)
	new_btn.grab_click_focus()


func _on_Title_text_changed() -> void:
	if !active_btn: return
	var _text : String = $VBoxContainer/HSplitContainer/Panel2/VBoxContainer/Title.text
	active_btn.text = _text
	active_note.title = _text


func _on_Note_text_changed() -> void:
	if !active_btn: return
	active_note.text = $VBoxContainer/HSplitContainer/Panel2/VBoxContainer/Note.text


func _on_click_add_button() -> void:
	$VBoxContainer/Title._wobble()
	add_button()
	
	
func _on_note_btn_clicked(_note : NoteResource, _btn : Button) -> void:
	# saves the previously active note
	if !_btn.deleting:
		if active_note:
			active_note.date_modified = OS.get_datetime()
		save()
	
	if _btn.deleting:
		reset_state()
		return
	# set the new active note
	active_note = _note
	active_btn = _btn
	$VBoxContainer/HSplitContainer/Panel2/VBoxContainer/Title.text = active_note.title
	$VBoxContainer/HSplitContainer/Panel2/VBoxContainer/Note.text = active_note.text
	$VBoxContainer/HSplitContainer/Panel2/VBoxContainer/HBoxContainer/Created.text = Defaults.get_date_with_time_string(_note.date_created)
	$VBoxContainer/HSplitContainer/Panel2/VBoxContainer/HBoxContainer/Modified.text = Defaults.get_date_with_time_string(_note.date_modified)
