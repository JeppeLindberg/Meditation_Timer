extends TextureButton

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

var target_meditation
var target_key: String
var target_option

var _prev_button_pressed = false

var _main_scene
var _settings_menu


func _ready():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_settings_menu = get_node(_scene_paths.SETTINGS_MENU)

func _process(_delta):		
	if _prev_button_pressed == true and button_pressed == false:		
		if _main_scene.is_hovering(self):
			_button_pressed()

	_prev_button_pressed = button_pressed


func _button_pressed():
	if target_key == "Duration":
		target_meditation.duration_mins = target_option
	
	_settings_menu.move_to_meditation_menu()