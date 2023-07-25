extends TextureButton

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

@export var inactive_texture: Texture2D
@export var active_texture: Texture2D
@export var inactive_color: Color
@export var active_color: Color
var target_meditation
var target_key: String
var target_option

var _prev_button_pressed = false

var _main_scene
var _settings_menu
var _texture
var _text


func _ready():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_settings_menu = get_node(_scene_paths.SETTINGS_MENU)
	_texture = get_node("texture")
	_text = get_node("text")

func _process(_delta):
	if _prev_button_pressed == true and button_pressed == false:		
		if _main_scene.is_hovering(self):
			_button_pressed()

	var active = true

	if target_key == "Duration" and target_meditation.duration_mins == target_option:
		active = false
	elif target_key == "Interval" and target_meditation.interval_mins == target_option:
		active = false
	elif target_key == "Secondary interval" and target_meditation.secondary_interval_mins == target_option:
		active = false

	if active:
		_texture.texture = active_texture
		_text.add_theme_color_override("font_color", active_color)
	else:
		_texture.texture = inactive_texture
		_text.add_theme_color_override("font_color", inactive_color)

	_prev_button_pressed = button_pressed


func _button_pressed():
	if target_key == "Duration":
		target_meditation.duration_mins = target_option
	elif target_key == "Interval":
		target_meditation.interval_mins = target_option
	elif target_key == "Secondary interval":
		target_meditation.secondary_interval_mins = target_option
	
	if target_meditation != null:
		target_meditation.update_meditation_settings_user_data()
	
	_settings_menu.close_menu()
