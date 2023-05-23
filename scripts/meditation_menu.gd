extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

@export var move_curve: Curve

var _main_scene
var _main_menu
var _under_top_panel_pos
var _bottom_pos
var _blackout

var active = false
var _activated_at = -1.0


func start():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_main_menu = get_node(_scene_paths.MAIN_MENU)
	_bottom_pos = get_node(_scene_paths.BOTTOM_ANCHOR).global_position
	_under_top_panel_pos = get_node(_scene_paths.UNDER_TOP_PANEL_ANCHOR).global_position
	_blackout = get_node("blackout")

func _process(_delta):
	var weight = move_curve.sample(_main_scene.seconds() - _activated_at)
	if not active:
		weight = 1.0 - weight
	global_position = lerp(_bottom_pos, _under_top_panel_pos, weight)
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


