extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

var _main_scene
var _main_menu
var _meditation_menu
var _settings_menu

var _slide_in_pivot
var _slide_in_black_1
var _slide_in_black_2
var _slide_in_black_3
var _slide_in_black_4
var _slide_in_green_1
var _slide_in_green_2
var _slide_in_green_3
var _slide_in_green_4

var _main_menu_background
var _meditation_menu_background
var _settings_menu_background

var _settings_menu_center
var _settings_menu_content

@export var intro_curve: Curve
@export var move_curve: Curve
@export var intro_delay: float
@export var start_delay: float
@export var move_delay: float

var top_left = Vector2.ZERO
var top_center = Vector2.ZERO
var bottom_left = Vector2.ZERO
var bottom_center = Vector2.ZERO
var main_menu_buttons = Vector2.ZERO
var center = Vector2.ZERO
var center_off_top = Vector2.ZERO
var center_off_bottom = Vector2.ZERO
var screen_size

var _activated_at = -1.0
var _debug_label: Label


func _ready():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_main_menu = get_node(_scene_paths.MAIN_MENU)
	_meditation_menu = get_node(_scene_paths.MEDITATION_MENU)
	_settings_menu = get_node(_scene_paths.SETTINGS_MENU)
	
	_slide_in_pivot = _main_menu.get_node("top/center_icons/container/icon_container/icon/slide_in_pivot")

	_slide_in_black_1 = _main_menu.get_node("slide_in_control/slide_in_black_1")
	_slide_in_black_2 = _main_menu.get_node("slide_in_control/slide_in_black_2")
	_slide_in_black_2.rotation_degrees = 90
	_slide_in_black_3 = _main_menu.get_node("slide_in_control/slide_in_black_3")
	_slide_in_black_3.rotation_degrees = 180
	_slide_in_black_4 = _main_menu.get_node("slide_in_control/slide_in_black_4")
	_slide_in_black_4.rotation_degrees = 270

	_slide_in_green_1 = _main_menu.get_node("slide_in_control/slide_in_green_1")
	_slide_in_green_2 = _main_menu.get_node("slide_in_control/slide_in_green_2")
	_slide_in_green_2.rotation_degrees = 90
	_slide_in_green_3 = _main_menu.get_node("slide_in_control/slide_in_green_3")
	_slide_in_green_3.rotation_degrees = 180
	_slide_in_green_4 = _main_menu.get_node("slide_in_control/slide_in_green_4")
	_slide_in_green_4.rotation_degrees = 270

	_main_menu_background = _main_menu.get_node("background")
	_meditation_menu_background = _meditation_menu.get_node("background")
	_settings_menu_background = _settings_menu.get_node("background")

	_settings_menu_center = _settings_menu.get_node("center")
	_settings_menu_content = _settings_menu.get_node("center/content_parent")

	_activated_at = _main_scene.seconds()

func start():
	_debug_label = get_node("debug_label")

func _process(_delta):
	screen_size = get_viewport().get_visible_rect().size

	_debug_label.text = str(screen_size.x) + "\n" + str(screen_size.y)

	top_left = Vector2(0, 0)
	top_center = Vector2(screen_size.x * 0.5, 0)
	bottom_left = Vector2(0, screen_size.y)
	bottom_center = Vector2(screen_size.x * 0.5, screen_size.y)
	main_menu_buttons = Vector2(screen_size.x * 0.5, screen_size.y * 0.58)
	center = Vector2(screen_size.x * 0.5, screen_size.y * 0.45)
	center_off_top = Vector2(screen_size.x * 0.5, screen_size.y * 0.20)
	center_off_bottom = Vector2(screen_size.x * 0.5, screen_size.y * 0.80)

	_main_menu_background.size = screen_size
	_meditation_menu_background.size = screen_size
	_settings_menu_background.size = screen_size

	_settings_menu_center.position = Vector2(screen_size.x * 0.5, _settings_menu_content.size.y * 0.5)
	
	var secs_since_activation = _main_scene.seconds() - _activated_at

	if secs_since_activation < 10.0:
		_process_slide_in(secs_since_activation)

func _process_slide_in(secs_since_activation):
	var weight = intro_curve.sample(secs_since_activation - intro_delay)
	_slide_in_black_1.global_position = _slide_in_pivot.global_position + Vector2(screen_size.x, -screen_size.y) * weight
	_slide_in_black_2.global_position = _slide_in_pivot.global_position + Vector2(screen_size.x, screen_size.y) * weight
	_slide_in_black_3.global_position = _slide_in_pivot.global_position + Vector2(-screen_size.x, screen_size.y) * weight
	_slide_in_black_4.global_position = _slide_in_pivot.global_position + Vector2(-screen_size.x, -screen_size.y) * weight

	weight = intro_curve.sample(secs_since_activation - intro_delay * 2)
	_slide_in_green_1.global_position = _slide_in_pivot.global_position + Vector2(screen_size.x, -screen_size.y) * weight
	_slide_in_green_2.global_position = _slide_in_pivot.global_position + Vector2(screen_size.x, screen_size.y) * weight
	_slide_in_green_3.global_position = _slide_in_pivot.global_position + Vector2(-screen_size.x, screen_size.y) * weight
	_slide_in_green_4.global_position = _slide_in_pivot.global_position + Vector2(-screen_size.x, -screen_size.y) * weight

	weight = 1.0 - move_curve.sample(secs_since_activation - start_delay)
	top_left = lerp(top_left, Vector2(0, screen_size.y * 0.5 - 370), weight)
	top_center = lerp(top_center, Vector2(screen_size.x * 0.5, screen_size.y * 0.5 - 370), weight)

	weight = 1.0 - move_curve.sample(secs_since_activation - start_delay - move_delay)
	main_menu_buttons += Vector2(0, weight * screen_size.y)

	weight = 1.0 - move_curve.sample(secs_since_activation - start_delay - move_delay*2)
	bottom_center += Vector2(0, weight * screen_size.y)

