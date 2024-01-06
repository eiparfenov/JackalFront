extends Sprite2D


func open_frame(num: int, rot: int = randi_range(0, 3)):
	frame = num
	rotation_degrees = rot * 90


func recalculate_children(corrector = []):
	var children_count = get_child_count() - corrector.size()
	var counter = 0 
	for child in get_children():
		if child.name not in corrector:
			child.position = children_position[children_count][counter]
			counter += 1


func _on_child_entered_tree():
	recalculate_children()


func _on_child_exiting_tree(node):
	recalculate_children([node.name])


var children_position = {1: [
							Vector2(0, 0)
							], 
						 2: [
							Vector2(50, 50), 
							Vector2(-50, -50)
							], 
						 3: [
							Vector2(50, 50), 
							Vector2(0, -50), 
							Vector2(-50, 50)
							], 
						 4: [
							Vector2(50, 50), 
							Vector2(50, -50), 
							Vector2(-50, 50), 
							Vector2(-50, -50)
							],
						 5: [
							Vector2(50, 50), 
							Vector2(50, -50), 
							Vector2(-50, 50), 
							Vector2(-50, -50), 
							Vector2(0, 0)
							],
						 6: [
							Vector2(50, 50), 
							Vector2(50, -50), 
							Vector2(-50, 50), 
							Vector2(-50, -50), 
							Vector2(50, 0), 
							Vector2(-50, 0)
							],
						 7: [
							Vector2(50, 50), 
							Vector2(50, -50), 
							Vector2(-50, 50), 
							Vector2(-50, -50), 
							Vector2(67, 0), 
							Vector2(-67, 0), 
							Vector2(0, 0)
							],
						 8: [
							Vector2(67, 67), 
							Vector2(67, -67), 
							Vector2(-67, 67), 
							Vector2(-67, -67),
							Vector2(50, 0), 
							Vector2(-50, 0), 
							Vector2(0, 67), 
							Vector2(0, -67)
							],
						 9: [
							Vector2(67, 67), 
							Vector2(67, -67), 
							Vector2(-67, 67), 
							Vector2(-67, -67), 
							Vector2(67, 0), 
							Vector2(-67, 0), 
							Vector2(0, 67), 
							Vector2(0, -67), 
							Vector2(0, 0)
							],
						 10: [
							Vector2(67, 75), 
							Vector2(67, -75), 
							Vector2(-67, 75), 
							Vector2(-67, -75), 
							Vector2(50, 25), 
							Vector2(-50, 25), 
							Vector2(0, 75), 
							Vector2(0, -75), 
							Vector2(50, -25), 
							Vector2(-50, -25)
							],
						 11: [
							Vector2(67, 75), 
							Vector2(67, -75), 
							Vector2(-67, 75), 
							Vector2(-67, -75), 
							Vector2(67, 25), 
							Vector2(-67, 25), 
							Vector2(0, 75), 
							Vector2(0, -75), 
							Vector2(67, -25), 
							Vector2(-67, -25), 
							Vector2(0, 0)
							],
						 12: [
							Vector2(67, 75), 
							Vector2(67, -75), 
							Vector2(-67, 75), 
							Vector2(-67, -75), 
							Vector2(67, 25), 
							Vector2(-67, 25), 
							Vector2(0, 75), 
							Vector2(0, -75), 
							Vector2(67, -25), 
							Vector2(-67, -25), 
							Vector2(0, 25), 
							Vector2(0, -25)
							],
						 13: [
							Vector2(75, 75), 
							Vector2(75, -75), 
							Vector2(-75, 75), 
							Vector2(-75, -75), 
							Vector2(67, 25), 
							Vector2(-67, 25), 
							Vector2(-25, 75), 
							Vector2(25, -75), 
							Vector2(67, -25), 
							Vector2(-67, -25), 
							Vector2(25, 75), 
							Vector2(-25, -75), 
							Vector2(0, 0)
							],
						 14: [
							Vector2(75, 75), 
							Vector2(75, -75), 
							Vector2(-75, 75), 
							Vector2(-75, -75), 
							Vector2(67, 25), 
							Vector2(-67, 25), 
							Vector2(-25, 75), 
							Vector2(25, -75), 
							Vector2(67, -25), 
							Vector2(-67, -25), 
							Vector2(25, 75), 
							Vector2(-25, -75), 
							Vector2(0, 25), 
							Vector2(0, -25)
							],
						 15: [
							Vector2(75, 75), 
							Vector2(75, -75), 
							Vector2(-75, 75), 
							Vector2(-75, -75), 
							Vector2(67, 25), 
							Vector2(-67, 25), 
							Vector2(-25, 75), 
							Vector2(25, -75), 
							Vector2(67, -25), 
							Vector2(-67, -25), 
							Vector2(25, 75), 
							Vector2(-25, -75), 
							Vector2(25, 25), 
							Vector2(0, -25), 
							Vector2(-25, 25)
							],
						 16: [
							Vector2(75, 75), 
							Vector2(75, -75), 
							Vector2(-75, 75), 
							Vector2(-75, -75), 
							Vector2(75, 25), 
							Vector2(-75, 25), 
							Vector2(-25, 75), 
							Vector2(25, -75), 
							Vector2(75, -25), 
							Vector2(-75, -25), 
							Vector2(25, 75), 
							Vector2(-25, -75), 
							Vector2(25, 25), 
							Vector2(-25, -25), 
							Vector2(-25, 25), 
							Vector2(25, -25)
							]}
