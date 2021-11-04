extends Control

export var title : String

var res: ToDoResource

var tasks_array : Array = []

var active : bool = false

var current_project : String
var current_project_id : int
var current_project_child_id : int

func _ready() -> void:
	$VBoxContainer/HSplitContainer/PanelL/ScrollContainer/ProjectButtons/ProjectButton.hide()
	$VBoxContainer/HSplitContainer/PanelR/TaskScroll/TaskList/TODOitem.hide()
	Defaults.connect("theme_changed", self, "on_theme_changed")
	update_theme()
	res = load(Defaults.TODOS_SAVE_PATH + Defaults.TODOS_SAVE_NAME)
	load_projects()
	load_tasks()


func update_theme() -> void:
#	for i in $VBoxContainer/HSplitContainer/PanelL/ScrollContainer/ProjectButtons.get_children():
#		update_theme()
	pass

func entering_view() -> void:
	Defaults.active_view_pointer = self
	Defaults.emit_signal("view_changed", title, true, true)
	active = true
	set_process_input(true)
	
	
func leaving_view() -> void:
	active = false
	set_process_input(false)
	
	
func save() -> void:
	Defaults.save_todo_resource(res)


func load_projects() -> void:
	for i in res.projects:
		create_project_button(res.projects[i].name, i)


func load_tasks() -> void:
	for i in res.tasks:
		var item = res.tasks[i]
		
		item["id"] = i
		tasks_array.append(item)
		
#	for i in tasks_array:
#		add_new_task_visual(i["text"], i["done"], i["date"], i["id"])
	
	
func add_new_task_visual(task_dic : Dictionary) -> void:
	# get it!
	var new : Panel = $VBoxContainer/HSplitContainer/PanelR/TaskScroll/TaskList/TODOitem.duplicate()
	# signals
	new.connect("task_text_changed", self, "_on_task_text_changed")
	new.connect("task_set_done", self, "_on_task_set_done")
	new.connect("task_delete", self, "_on_task_delete")
	new.connect("task_time_track", self, "_on_task_time_track")
	
	#setup
#	print(task_dic)
	new.idx = task_dic.id
	new.update_self(task_dic.text, task_dic.done, task_dic.date, task_dic.id)
	new.show()
	
	#child stuff
	$VBoxContainer/HSplitContainer/PanelR/TaskScroll/TaskList.add_child(new)
	$VBoxContainer/HSplitContainer/PanelR/TaskScroll/TaskList.move_child(new, 1)
		
	
func create_project_button(_p_name : String = "", id: int = -1) -> void:
	var new : Button = $VBoxContainer/HSplitContainer/PanelL/ScrollContainer/ProjectButtons/ProjectButton.duplicate()
	new.text = _p_name
	new.id = id
#	new.set_percent_done(res.get_percent_done(id))
	new.call_deferred("set_percent_done", res.get_percent_done(id))
	new.connect("delete_project", self, "on_delete_project")
	$VBoxContainer/HSplitContainer/PanelL/ScrollContainer/ProjectButtons.add_child(new)
	new.show()
	
	
func remove_task_visual() -> void:
	pass
	
	
func reset_tasks_view() -> void:
#	$VBoxContainer/HSplitContainer/PanelR/TaskScroll/TaskList/ProjectLineEdit.clear()
	for i in $VBoxContainer/HSplitContainer/PanelR/TaskScroll/TaskList.get_children():
		if i.name != "TODOitem" and i.name != "ProjectLineEdit":
			i.queue_free()
	
	
func update_percent_done(p_id : int, child_p_id : int) -> void:
	$VBoxContainer/HSplitContainer/PanelL/ScrollContainer/ProjectButtons.get_child(child_p_id).set_percent_done(res.get_percent_done(p_id))
	
	
# TODO: Implement method for removing a project.
# Should remove all tasks with it by default as well
func remove_project() -> void:
	pass
	
	
func update_task_text(idx : int, text : String) -> void:
	res.tasks[idx].text = text
	
	
func update_task_done(idx : int, done : bool) -> void:
	res.tasks[idx].done = done
	if done:
		res.tasks[idx].done_date = OS.get_datetime()
	else:
		res.tasks[idx].done_date = {}
	update_percent_done(current_project_id, current_project_child_id)
	
	
func remove_task_from_resource(idx : int) -> void:
	res.tasks.erase(idx)


func _on_NewTask_pressed() -> void:
	res.add_new_task($VBoxContainer/HBoxContainer/TODO/HBoxContainer/NewTaskName.text, false, OS.get_datetime(), {}, current_project_id)


func _on_task_text_changed(_name : String, idx : int) -> void:
	update_task_text(idx, _name)
	
	
func _on_task_delete(idx : int) -> void:
	remove_task_from_resource(idx)


func _on_task_time_track(text : String) -> void:
	get_parent().start_custom_time_track(text)


func _on_task_set_done(really : bool, idx : int) -> void:
	update_task_done(idx, really)


func on_new_top_bar_button(message : Dictionary = {}) -> void:
	var nm : String = "New Project " + str(res.get_new_project_id())
	if message.has("text"):
		nm = message.text
	var _id : int = res.add_project(nm)
	create_project_button(nm, _id)


func _on_ProjectButton_selected_project(_name, index, child_id) -> void:
	# show the necessary nodes
	$VBoxContainer/HSplitContainer/PanelR/TaskScroll/TaskList/ProjectLineEdit.show()
	$VBoxContainer/HSplitContainer/PanelR/NewTodoBtn.show()
	
	$VBoxContainer/HSplitContainer/PanelR/TaskScroll/TaskList/ProjectLineEdit.text = _name
	# cancel if we've clicked the same one
	if _name == current_project: return
	current_project = _name
	current_project_id = index
	current_project_child_id = child_id
	reset_tasks_view()
	for i in res.get_tasks_in_project(current_project_id):
		var task = res.tasks[i]
		add_new_task_visual(task)


func _on_NewTodoBtn_pressed() -> void:
	print("Adding a new button")
	var new_task : Dictionary = res.add_new_task("new_task", false, OS.get_datetime(), {}, current_project_id)
	add_new_task_visual(new_task)


func _on_ProjectLineEdit_text_changed(new_text: String) -> void:
	if current_project_id == -1:
		return
	res.change_project_name(new_text, current_project_id)
	$VBoxContainer/HSplitContainer/PanelL/ScrollContainer/ProjectButtons.get_child(current_project_child_id).text = new_text
	

func on_delete_project(id : int) -> void:
	current_project_id = -1
	res.delete_project(id)
	reset_tasks_view()
	


func on_theme_changed() -> void:
	update_theme()


func _on_Debug_pressed() -> void:
	res.clean_dangling_tasks()
