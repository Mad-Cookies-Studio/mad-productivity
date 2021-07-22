class_name ToDoResource
extends Resource

export(Dictionary) var tasks
export(String) var save_name
export(String) var date_modified
export(String) var date_created
export(Dictionary) var projects
export(int) var top_id = 0
export(int) var project_top_id = 0
export(int) var version : = 0

func get_tasks_in_project(idx : int) -> Dictionary:
	var dic : Dictionary
	for i in tasks:
		if tasks[i].project == idx:
			dic[i] = tasks[i]
	
	return dic
	
	
func get_new_project_id() -> int:
	return project_top_id
	
	
func add_project(_name : String) -> int:
	var _new_p_id = project_top_id
	var project_data : Dictionary = {
		"name" : _name
		}
	projects[_new_p_id] = project_data
	project_top_id += 1
	return _new_p_id
	
	
func delete_project(id : int) -> void:
	projects.erase(id)
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
		"id" : top_id
	}
	tasks[top_id] = word_dic
		
	top_id += 1
		
	return word_dic


func change_project_name(_new : String, id : int) -> void:
	projects[id].name = _new


func update_task_project_id(_new : int, _old : int) -> void:
	for i in tasks:
		if tasks[i].project == _old:
			tasks[i].project = _new
