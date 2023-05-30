extends TextureButton

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

@export var unpressed_play_texture: Texture
@export var pressed_play_texture: Texture
@export var unpressed_pause_texture: Texture
@export var pressed_pause_texture: Texture

var _prev_button_pressed = false

var _main_scene
var _meditation_menu


func start():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_meditation_menu = get_node(_scene_paths.MEDITATION_MENU)

func _process(_delta):	
	if _meditation_menu.is_playing() == false:
		self.texture_normal = unpressed_play_texture
		self.texture_pressed = pressed_play_texture

	elif _meditation_menu.is_playing() == true:
		self.texture_normal = unpressed_pause_texture
		self.texture_pressed = pressed_pause_texture
		
	if _prev_button_pressed == true and button_pressed == false:		
		if _main_scene.is_hovering(self):
			_button_pressed()

	_prev_button_pressed = button_pressed


func _button_pressed():
	if _meditation_menu.active:
		if _meditation_menu.is_playing() == false:
			_meditation_menu.play()
		elif _meditation_menu.is_playing() == true:
			_meditation_menu.pause()
