extends TextureButton

@export var unpressed_panel_texture: Texture
@export var pressed_panel_texture: Texture

var _panel: NinePatchRect
var _other_nodes

var _prev_button_pressed = false


func activate():
	_panel = get_node("panel")
	_other_nodes = get_children()
	for i in range(len(_other_nodes)):
		if _other_nodes[i] == _panel:
			_other_nodes.pop_at(i)
			break


func _process(_delta):
	if _prev_button_pressed == false and button_pressed == true:
		_panel.texture = pressed_panel_texture
	if _prev_button_pressed == true and button_pressed == false:
		_panel.texture = unpressed_panel_texture
		if is_hovered():
			_button_pressed()

	_prev_button_pressed = button_pressed
	

func _button_pressed():
	print("bla")
