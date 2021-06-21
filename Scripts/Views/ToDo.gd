extends Control

var res: ToDoResource

var tasks_array : Array = []

var active : bool = false

func _ready() -> void:
	res = load(Defaults.TODOS_SAVE_PATH + Defaults.TODOS_SAVE_NAME)
	load_tasks()

func entering_view() -> void:
	active = true
	set_process_input(true)
	
	
func leaving_view() -> void:
	active = false
	set_process_input(false)
	
	
func save() -> void:
	Defaults.save_todo_resource(res)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and active:
		add_new_task_to_resource($VBoxContainer/HBoxContainer/TODO/HBoxContainer/NewTaskName.text, false, OS.get_datetime(), {})
		$VBoxContainer/HBoxContainer/TODO/HBoxContainer/NewTaskName.text = ""


func load_tasks() -> void:
	for i in res.tasks:
		var item = res.tasks[i]
		
		item["id"] = i
		tasks_array.append(item)
		
	for i in tasks_array:
		add_new_task_visual(i["text"], i["done"], i["date"], i["id"])


func add_new_task_to_resource(_text : String, _done : bool, _date : Dictionary, _done_date : Dictionary) -> void:
	res.tasks[res.tasks.size() + 1] = {
		"text" : _text,
		"done" : false,
		"date" : OS.get_datetime(),
		"done_date" : {}
	}
	add_new_task_visual(_text, _done, _date, res.tasks.size())
	
	
func add_new_task_visual(_text : String, _done : bool, _date : Dictionary, _idx : int) -> void:
	# get it!
	var new : ColorRect = $VBoxContainer/HBoxContainer/TODO/ScrollContainer/VBoxContainer/TODOitem.duplicate()
	# signals
	new.connect("task_text_changed", self, "_on_task_text_changed")
	new.connect("task_set_done", self, "_on_task_set_done")
	new.connect("task_delete", self, "_on_task_delete")
	new.connect("task_time_track", self, "_on_task_time_track")
	
	
	#setup
	new.idx = _idx
	new.update_self(_text, _done, _date, _idx)
	new.show()
	
	#child stuff
	$VBoxContainer/HBoxContainer/TODO/ScrollContainer/VBoxContainer.add_child(new)
	$VBoxContainer/HBoxContainer/TODO/ScrollContainer/VBoxContainer.move_child(new, 1)
		
	
	
func remove_task_visual() -> void:
	pass
	
	
func update_task_text(idx : int, text : String) -> void:
	res.tasks[idx].text = text
	
	
func update_task_done(idx : int, done : bool) -> void:
	res.tasks[idx].done = done
	
	
func remove_task_from_resource(idx : int) -> void:
	res.tasks.erase(idx)


func _on_NewTask_pressed() -> void:
	add_new_task_to_resource($VBoxContainer/HBoxContainer/TODO/HBoxContainer/NewTaskName.text, false, OS.get_datetime(), {})


func _on_task_text_changed(_name : String, idx : int) -> void:
	update_task_text(idx, _name)
	
	
func _on_task_delete(idx : int) -> void:
	remove_task_from_resource(idx)


func _on_task_time_track(text : String) -> void:
	get_parent().start_custom_time_track(text)


func _on_task_set_done(really : bool, idx : int) -> void:
	update_task_done(idx, really)
