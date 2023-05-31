extends TextureButton

@export var stop_normal: Texture2D
@export var stop_pressed: Texture2D
@export var settings_normal: Texture2D
@export var settings_pressed: Texture2D

var _latest_textures = ""


func stop_texture():
	if _latest_textures != "stop_texture":
		self.texture_normal = stop_normal
		self.texture_pressed = stop_pressed
		_latest_textures = "stop_texture"

func settings_texture():
	if _latest_textures != "settings_texture":
		self.texture_normal = settings_normal
		self.texture_pressed = settings_pressed
		_latest_textures = "settings_texture"
