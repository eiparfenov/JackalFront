extends Sprite2D


func open_frame(num: int, rot: int = randi_range(0, 3)):
	frame = num
	rotation_degrees = rot * 90


func recalculate_children(corrector = [], extra_nodes = 1):
	var children_count = get_child_count() - corrector.size() - extra_nodes
	var counter = 0 
	for child in get_children():
		if child.name not in corrector and child is Node2D == false:
			child.position = Variable.children_position[children_count][counter]
			counter += 1


func _on_child_entered_tree(node):
	recalculate_children() 


func _on_child_exiting_tree(node):
	recalculate_children([node.name]) 
