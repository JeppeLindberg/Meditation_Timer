extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

var _under_top_panel_pos
var _bottom_pos


func activate():
	_bottom_pos = get_node(_scene_paths.BOTTOM_ANCHOR).global_position
	_under_top_panel_pos = get_node(_scene_paths.UNDER_TOP_PANEL_ANCHOR).global_position





