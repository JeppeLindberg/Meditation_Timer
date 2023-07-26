extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

var _setting_path = "res://prefabs/setting.tscn"
var _settings_button_path = "res://prefabs/settings_button.tscn"
var _settings_text_path = "res://prefabs/settings_text.tscn"
var _settings_button_container_path = "res://prefabs/settings_buttons_container.tscn"

@export var move_curve: Curve
@export var blackout_percentage: float

var active = false
var _return_menu = ""
var _activated_at = -1.0

var _main_scene
var _meditation_menu
var _main_menu
var _user_data
var _screen_size
var _content
var _content_text
var _content_parent
var _blackout


func start():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_screen_size = get_node(_scene_paths.SCREEN_SIZE)
	_meditation_menu = get_node(_scene_paths.MEDITATION_MENU)
	_main_menu = get_node(_scene_paths.MAIN_MENU)
	_user_data = get_node(_scene_paths.USER_DATA)
	_blackout = get_node("blackout")
	_content_parent = get_node("center/content_parent")
	_content = get_node("center/content_parent/content")
	_content_text = get_node("center/content_parent/content_text")

func handle_back_request():
	close_menu()

func activate_credits_menu():
	var settings_dict = {}
	settings_dict[""] = ["Back"]

	var line_1 = "Credits:"
	var line_2 = "App by Sort Sol Games\n\nSound effects obtained from\nwww.zapsplat.com"

	_return_menu = "main"
	_activate_menu(line_1, line_2, settings_dict, null)

func activate_save_time_menu(meditation):
	var settings_dict = {}
	settings_dict[""] = ["Back"]

	var total_time_mins = _user_data.get_total_meditation_time()
	var line_1 = "Minutes meditated:"
	var line_2 = str(int(total_time_mins))

	_return_menu = "meditation"
	_activate_menu(line_1, line_2, settings_dict, meditation)

func activate_menu(meditation):
	var settings_dict = {}
	settings_dict["Duration"] = meditation.possible_durations

	if len(meditation.possible_intervals) > 0:
		settings_dict["Interval"] = meditation.possible_intervals
	if len(meditation.possible_secondary_intervals) > 0:
		settings_dict["Secondary interval"] = meditation.possible_secondary_intervals
	
	settings_dict[""] = ["Back"]

	_return_menu = "meditation"
	_activate_menu("", "", settings_dict, meditation)

func _activate_menu(text_line_1, text_line_2, settings_dict, meditation):
	active = true
	_activated_at = _main_scene.seconds()
	_main_scene.make_clickable(self)

	for child in _content.get_children():
		child.queue_free()

	for child in _content_text.get_children():
		child.queue_free()	
	
	for key in settings_dict.keys():
		var setting = _main_scene.create_node(_setting_path, _content)
		var setting_title = setting.get_node("title")
		setting_title.text = key

		var setting_buttons_container = null
		var i = 0
		for option in settings_dict[key]:
			if i == 0:
				setting_buttons_container = _main_scene.create_node(_settings_button_container_path, setting)
				
			var settings_button = _main_scene.create_node(_settings_button_path, setting_buttons_container)
			settings_button.target_meditation = meditation
			settings_button.target_key = key
			settings_button.target_option = option

			var settings_button_text = settings_button.get_node("text")
			if key == "Duration":
				settings_button_text.text = _main_scene.to_time_str(option * 60)
			elif key == "Interval":
				if option == 0.0:
					settings_button_text.text = "Off"
				else:
					settings_button_text.text = _main_scene.to_time_str(option * 60)
			elif key == "Secondary interval":
				if option == 0.0:
					settings_button_text.text = "Off"
				else:
					settings_button_text.text = "On"
			else:
				settings_button_text.text = option

			i += 1
			if i == 2:
				i = 0
		
	if not text_line_1 == "":
		var settings_text = _main_scene.create_node(_settings_text_path, _content_text)
		var rich_text = settings_text.get_node("settings_text/text")
		rich_text.text = "[center]%1\n\n%2[/center]".replace("%1", text_line_1).replace("%2", text_line_2)

func close_menu():
	active = false
	_activated_at = _main_scene.seconds()
	if _return_menu == "meditation":
		_main_scene.make_clickable(_meditation_menu)
	elif _return_menu == "main":
		_main_scene.make_clickable(_main_menu)

func _process(_delta):
	var secs_since_activation = _main_scene.seconds() - _activated_at
	var weight = move_curve.sample(secs_since_activation)
	if not active:
		weight = 1.0 - weight

	if active or secs_since_activation < 1.0:
		_process_visual(weight)

func _process_visual(weight):
	var pos_1 = _screen_size.bottom_left
	var pos_2 = _screen_size.bottom_left - Vector2(0, _content_parent.size.y-10)
	global_position = lerp(pos_1, pos_2, weight)
	_blackout.color = Color(0, 0, 0, weight * blackout_percentage)
