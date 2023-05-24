extends Node2D

var _cursor_pos = Vector2.ZERO


func _ready():
	_start_node(self)
	
func _start_node(node):
	if node.has_method("start"):
		node.start()

	for child in node.get_children():
		_start_node(child)

func _input(event):
	if event is InputEventMouse or \
		event is InputEventScreenTouch:
		_cursor_pos = event.position

func seconds():
	return float(Time.get_ticks_msec()) / 1000.0

func make_clickable(node):
	node.move_to_front()

func is_hovering(node):
	if node is Control:
		return _cursor_pos.x >= node.global_position.x and \
			node.global_position.x + node.size.x >= _cursor_pos.x and \
			_cursor_pos.y >= node.global_position.y and \
			node.global_position.y + node.size.y >= _cursor_pos.y
	
	return false


