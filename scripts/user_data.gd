extends Node2D

var _user_identifier = "local_user"
var _user_data_path = null


func _find_user_data_path():
	if _user_data_path == null:
		_user_data_path = ProjectSettings.globalize_path("user://%1.json".replace("%1", _user_identifier))
		print(_user_data_path)

func _exists(path):
	return FileAccess.file_exists(path)

func _create_empty_user_data_json():
	_write_user_data({"meditation_settings": {}, "meditation_sessions": []})

func _read_user_data():
	_find_user_data_path()

	var user_data_file = FileAccess.open(_user_data_path, FileAccess.READ)
	var user_data = user_data_file.get_line()
	var dict = JSON.parse_string(user_data)

	return dict

func _write_user_data(dict):
	_find_user_data_path()

	var user_data_file = FileAccess.open(_user_data_path, FileAccess.WRITE)
	var json_string = JSON.stringify(dict)

	user_data_file.store_line(json_string)

func read_meditation_settings(meditation):
	_find_user_data_path()
	if not _exists(_user_data_path):
		_create_empty_user_data_json()

	var user_data = _read_user_data()

	if not user_data["meditation_settings"].has(meditation.meditation_type):
		if len(meditation.possible_durations) > 0:
			meditation.duration_mins = meditation.possible_durations[0]
		if len(meditation.possible_intervals) > 0:
			meditation.interval_mins = meditation.possible_intervals[0]
		if len(meditation.possible_secondary_intervals) > 0:
			meditation.secondary_interval_mins = meditation.possible_secondary_intervals[0]

		user_data["meditation_settings"][meditation.meditation_type] = {
			"duration_mins": meditation.duration_mins,
			"interval_mins": meditation.interval_mins,
			"secondary_interval_mins": meditation.secondary_interval_mins,
		}

		_write_user_data(user_data)
	
	return user_data["meditation_settings"][meditation.meditation_type]

func write_meditation_settings(meditation):
	_find_user_data_path()
	if not _exists(_user_data_path):
		_create_empty_user_data_json()

	var user_data = _read_user_data()
	
	user_data["meditation_settings"][meditation.meditation_type] = {
		"duration_mins": meditation.duration_mins,
		"interval_mins": meditation.interval_mins,
		"secondary_interval_mins": meditation.secondary_interval_mins,
	}

	_write_user_data(user_data)

func save_meditation(meditation_name, duration_mins):
	_find_user_data_path()
	if not _exists(_user_data_path):
		_create_empty_user_data_json()

	var time = Time.get_datetime_dict_from_system()

	var new_meditation = \
	{
		"date": "%1/%2/%3"
			.replace("%1", str(time["year"]))
			.replace("%2", str(time["month"]))
			.replace("%3", str(time["day"])),
		"meditation": meditation_name,
		"duration": duration_mins,
	}

	var user_data_dict = _read_user_data()
	user_data_dict["meditation_sessions"] = user_data_dict["meditation_sessions"] + [new_meditation]

	_write_user_data(user_data_dict)

func get_total_meditation_time():
	var user_data_dict = _read_user_data()

	var total_time_mins = 0.0
	for meditation in user_data_dict["meditation_sessions"]:
		total_time_mins += meditation["duration"]
	
	return total_time_mins

