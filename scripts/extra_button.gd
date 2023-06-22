extends TextureButton

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

@export var stop_normal: Texture2D
@export var stop_pressed: Texture2D
@export var settings_normal: Texture2D
@export var settings_pressed: Texture2D

var _meditation_menu
var _main_scene

var _button_mode = ""
var _prev_button_pressed = false

func start():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_meditation_menu = get_node(_scene_paths.MEDITATION_MENU)

func stop_texture():
	if _button_mode != "stop":
		self.texture_normal = stop_normal
		self.texture_pressed = stop_pressed
		_button_mode = "stop"

func settings_texture():
	if _button_mode != "settings":
		self.texture_normal = settings_normal
		self.texture_pressed = settings_pressed
		_button_mode = "settings"


func _process(_delta):
	if _prev_button_pressed == true and button_pressed == false:
		if _main_scene.is_hovering(self):
			_button_pressed()

	_prev_button_pressed = button_pressed

func _button_pressed():
	if _button_mode == "stop":
		_meditation_menu.stop()
	if _button_mode == "settings":
		_meditation_menu.open_settings()

