extends Node2D

var top_left = Vector2.ZERO
var bottom_left = Vector2.ZERO
var center = Vector2.ZERO
var center_off_top = Vector2.ZERO
var center_off_bottom = Vector2.ZERO
var screen_size

var _debug_label: Label


func start():
	_debug_label = get_node("debug_label")

func _process(_delta):
	screen_size = get_viewport().get_visible_rect().size

	_debug_label.text = str(screen_size.x) + "\n" + str(screen_size.y)

	top_left = Vector2(0, 0)
	bottom_left = Vector2(0, screen_size.y)
	center = Vector2(screen_size.x * 0.5, screen_size.y * 0.5)
	center_off_top = Vector2(screen_size.x * 0.5, screen_size.y * 0.25)
	center_off_bottom = Vector2(screen_size.x * 0.5, screen_size.y * 0.75)

