extends Node2D



func _ready():
	_activate_node(self)
	get_node("under_top_panel_anchor")
	

func _activate_node(node):
	if node.has_method("activate"):
		node.activate()

	for child in node.get_children():
		_activate_node(child)


