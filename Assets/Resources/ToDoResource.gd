class_name ToDoResource
extends Resource

export(Dictionary) var tasks
export(String) var save_name
export(String) var date_modified
export(String) var date_created
export(Array) var projects : = ["Temporary task list"]
export(int) var top_id = 0

func get_tasks_in_project(idx : int) -> Dictionary:
	var dic : Dictionary
	for i in tasks:
		if tasks[i].project == idx:
			dic[i] = tasks[i]
	
	return dic
	
	
func get_id_in_projects_from_string(_name : String) -> int:
	return projects.find(_name, 0)
	
	
func get_project_list() -> Array:
	return projects
	
	
func add_project(_name : String) -> void:
	projects.append(_name)
	
	
func delete_project(id : int) -> void:
	projects.remove(id)
	for i in tasks:
		if tasks[i].project == id:
			tasks.erase(i)
	
	
func add_new_task(_text : String, _done : bool, _date : Dictionary, _done_date : Dictionary, _project : int) -> Dictionary:
	var word_dic = {
		"text" : _text,
		"done" : false,
		"date" : OS.get_datetime(),
		"project" : _project,
		"done_date" : {},
		"date_created" : OS.get_unix_time(),
		"id" : tasks.size() + 1
	}

	if top_id == 0:
		top_id = tasks.size() + 1

	tasks[top_id] = word_dic
		
	top_id += 1
		
	return word_dic


func change_project_name(_new : String, id : int) -> void:
	projects[id] = _new


func update_task_project_id(_new : int, _old : int) -> void:
	for i in tasks:
		if tasks[i].project == _old:
			tasks[i].project = _new
