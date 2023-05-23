extends Node2D



func _ready():
	_start_node(self)
	get_node("under_top_panel_anchor")
	

func _start_node(node):
	if node.has_method("start"):
		node.start()

	for child in node.get_children():
		_start_node(child)


func seconds():
	return float(Time.get_ticks_msec()) / 1000.0

func make_clickable(node):
	node.move_to_front()

