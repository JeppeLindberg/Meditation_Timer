extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

@export var move_curve: Curve
@export var half_shade_rpm: float
@export var full_shade_rpm: float

var _main_scene
var _main_menu
var _screen_size
var _blackout
var _center
var _half_shade
var _full_shade
var _half_shade_pivot
var _full_shade_pivot
var _current_time
var _full_time

var active = false
var playing = false
var _activated_at = -1.0


func start():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_main_menu = get_node(_scene_paths.MAIN_MENU)
	_blackout = get_node("blackout")
	_screen_size = get_node(_scene_paths.SCREEN_SIZE)
	_center = get_node("center")
	_half_shade = get_node("background/half_shade")
	_full_shade = get_node("background/full_shade")
	_half_shade_pivot = get_node("background/half_shade/pivot")
	_full_shade_pivot = get_node("background/full_shade/pivot")
	_current_time = get_node("center/center/container/timer/current_time")
	_full_time = get_node("center/center/container/timer/full_time")

func _process(_delta):
	var weight = move_curve.sample(_main_scene.seconds() - _activated_at)
	if not active:
		weight = 1.0 - weight

	if weight > -1.0:
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

func deactivate_menu():
	active = false
	_activated_at = _main_scene.seconds()

func move_to_main_menu():
	if active:
		deactivate_menu()
		_main_menu.activate_menu()

func play():
	playing = true

func pause():
	playing = false




