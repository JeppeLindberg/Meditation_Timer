extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

@export var move_curve: Curve

var _main_scene
var _main_menu
var _screen_size
var _blackout

var active = false
var _activated_at = -1.0


func start():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_main_menu = get_node(_scene_paths.MAIN_MENU)
	_blackout = get_node("blackout")
	_screen_size = get_node(_scene_paths.SCREEN_SIZE)

func _process(_delta):
	var weight = move_curve.sample(_main_scene.seconds() - _activated_at)
	if not active:
		weight = 1.0 - weight
	global_position = lerp(_screen_size.bottom_left, _screen_size.top_left, weight)
	_blackout.color = Color(0, 0, 0, weight)

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


