class_name TimeTrackResource
extends Resource

export(String) var project
export(int) var time_tracked
export(String) var save_name
export(Dictionary) var date_modified
export(Dictionary) var date_created
export(Dictionary) var tracks
export(bool) var pomodoro_on
export(int) var tracks_count
export(Dictionary) var track_back_up

func add_track(name : String) -> int:
	var item = TimeTrackItem.new()
	item.create_track(name)
	tracks_count += 1
	tracks[tracks_count] = item
	return tracks_count


func add_finished_track(item : TimeTrackItem) -> int:
	tracks_count += 1
	tracks[tracks_count] = item
	return tracks_count


func get_track(_id : int) -> TimeTrackItem:
	return tracks[_id]

#func get_track_length(id : int) -> Dictionary:
	#if id < 0:
		##id = tracks.length() -1

