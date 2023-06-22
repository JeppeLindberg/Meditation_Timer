extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

var _setting_path = "res://prefabs/setting.tscn"
var _settings_button_path = "res://prefabs/settings_button.tscn"
var _settings_button_container_path = "res://prefabs/settings_buttons_container.tscn"

@export var move_curve: Curve
@export var blackout_percentage: float

var active = false
var _activated_at = -1.0

var _main_scene
var _meditation_menu
var _screen_size
var _content
var _content_parent
var _blackout

func start():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_screen_size = get_node(_scene_paths.SCREEN_SIZE)
	_meditation_menu = get_node(_scene_paths.MEDITATION_MENU)
	_blackout = get_node("blackout")
	_content_parent = get_node("content_parent")
	_content = get_node("content_parent/content")

func activate_menu(settings_dict: Dictionary):
	active = true
	_activated_at = _main_scene.seconds()
	_main_scene.make_clickable(self)

	for child in _content.get_children():
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
			var settings_button_text = settings_button.get_node("text")
			settings_button_text.text = _main_scene.to_time_str(option * 60)

			i += 1
			if i == 2:
				i = 0


func move_to_meditation_menu():
	active = false
	_activated_at = _main_scene.seconds()
	_main_scene.make_clickable(_meditation_menu)

func _process(_delta):
	var secs_since_activation = _main_scene.seconds() - _activated_at
	var weight = move_curve.sample(secs_since_activation)
	if not active:
		weight = 1.0 - weight

	if active or secs_since_activation < 1.0:
		_process_visual(weight)

func _process_visual(weight):
	var pos_1 = _screen_size.bottom_left
	var pos_2 = _screen_size.bottom_left - Vector2(0, _content_parent.size.y)
	global_position = lerp(pos_1, pos_2, weight)
	_blackout.color = Color(0, 0, 0, weight * blackout_percentage)
