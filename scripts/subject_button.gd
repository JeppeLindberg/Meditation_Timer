extends TextureButton

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

@export var unpressed_panel_texture: Texture
@export var pressed_panel_texture: Texture

var _panel: NinePatchRect
var _other_nodes
var _main_menu
var _meditation_menu

var _prev_button_pressed = false


func start():
	_panel = get_node("panel")
	_other_nodes = get_children()
	for i in range(len(_other_nodes)):
		if _other_nodes[i] == _panel:
			_other_nodes.pop_at(i)
			break
	_main_menu = get_node(_scene_paths.MAIN_MENU)
	_meditation_menu = get_node(_scene_paths.MEDITATION_MENU)


func _process(_delta):
	if _prev_button_pressed == false and button_pressed == true and _main_menu.active:
		_panel.texture = pressed_panel_texture
	if _prev_button_pressed == true and button_pressed == false:
		_panel.texture = unpressed_panel_texture
		if is_hovered():
			_button_pressed()

	_prev_button_pressed = button_pressed
	

func _button_pressed():
	if _main_menu.active:
		_main_menu.deactivate_menu()
		_meditation_menu.activate_menu()
