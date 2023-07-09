extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()
var _prefab_paths := preload("res://scripts/library/prefab_paths.gd").new()

@export var move_curve: Curve
@export var half_shade_rpm: float
@export var full_shade_rpm: float

var _activated_at = -1.0
var _full_time
var _current_time

var _main_scene
var _main_menu
var _audio
var _current_meditation
var _screen_size
var _blackout
var _extra_button
var _settings_menu
var _center
var _half_shade
var _full_shade
var _half_shade_pivot
var _full_shade_pivot

var active = false


func start():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_main_menu = get_node(_scene_paths.MAIN_MENU)
	_audio = get_node(_scene_paths.AUDIO)
	_blackout = get_node("blackout")
	_screen_size = get_node(_scene_paths.SCREEN_SIZE)
	_center = get_node("center")
	_half_shade = get_node("background/half_shade")
	_full_shade = get_node("background/full_shade")
	_half_shade_pivot = get_node("background/half_shade/pivot")
	_full_shade_pivot = get_node("background/full_shade/pivot")
	_current_time = get_node("center/center/container/timer_container/timer/current_time")
	_full_time = get_node("center/center/container/timer_container/timer/full_time")
	_extra_button = get_node("center/center/container/extra_container/extra_button")
	_settings_menu = get_node(_scene_paths.SETTINGS_MENU)

func _process(_delta):
	var secs_since_activation = _main_scene.seconds() - _activated_at
	var weight = move_curve.sample(secs_since_activation)
	if not active:
		weight = 1.0 - weight

	if active or secs_since_activation < 1.0:
		_process_visual(weight)

func _process_visual(weight):
	if _current_meditation != null:
		_full_time.text = _main_scene.to_time_str(_current_meditation.duration_mins * 60)
		_current_time.text = _main_scene.to_time_str(_current_meditation.time_elapsed)

	if time_elapsed() > 0.0:
		_extra_button.stop_texture()
	else:
		_extra_button.settings_texture()

	global_position = lerp(_screen_size.bottom_left, _screen_size.top_left, weight)
	_blackout.color = Color(0, 0, 0, weight)		
	_center.position = _screen_size.center
	_half_shade.position = _screen_size.center_off_top
	_full_shade.position = _screen_size.center_off_bottom
	_half_shade_pivot.rotation_degrees = (_main_scene.seconds() / 60.0) * 360 * half_shade_rpm
	_full_shade_pivot.rotation_degrees = (_main_scene.seconds() / 60.0) * 360 * full_shade_rpm

func activate_menu():
	active = true
	_activated_at = _main_scene.seconds()
	_main_scene.make_clickable(self)
	
	_current_meditation = _main_scene.create_node(_prefab_paths.SILENCE, _audio)

func deactivate_menu():
	active = false
	_activated_at = _main_scene.seconds()

func move_to_main_menu():
	if active:
		deactivate_menu()
		_main_menu.activate_menu()

func open_settings():
	if active:
		_settings_menu.activate_menu(_current_meditation)

func is_playing():
	if _current_meditation == null:
		return false
	return _current_meditation.playing

func time_elapsed():
	if _current_meditation == null:
		return 0.0
	return _current_meditation.time_elapsed

func play():
	_current_meditation.play()

func pause():
	_current_meditation.pause()

func stop():
	_current_meditation.stop()




