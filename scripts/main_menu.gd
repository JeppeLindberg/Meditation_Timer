extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

var _main_scene

var active = true

func start():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)

func activate_menu():
	active = true
	_main_scene.make_clickable(self)

func deactivate_menu():
	active = false
