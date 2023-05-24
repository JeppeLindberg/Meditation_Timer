extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

var _main_scene
var _screen_size
var _center

var active = true

func start():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_screen_size = get_node(_scene_paths.SCREEN_SIZE)
	_center = get_node("center")

func _process(_delta):
	_center.global_position = _screen_size.center

func activate_menu():
	active = true
	_main_scene.make_clickable(self)

func deactivate_menu():
	active = false
