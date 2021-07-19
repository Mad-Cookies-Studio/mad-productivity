extends Resource

class_name TimeTrackItem

export(Array) var date_ranges
export(String) var name


func create_track(start : int, n : String) -> void:
	date_ranges += [[start]]
	name = n


func end_interval(end : int) -> void:
	date_ranges[-1] += [end]


func resume(start : int) -> void:
	date_ranges += [[start]]

func get_start_unix_time() -> int:
	return date_ranges[0][0]


func get_len(only_last : bool = false) -> int:
	var length : int = 0
	if only_last:
		length = date_ranges[-1][1] - date_ranges[-1][0]
	else:
		for datarange in date_ranges:
			if len(datarange) > 1:
				length += (datarange[1] - datarange[0])

	return length

