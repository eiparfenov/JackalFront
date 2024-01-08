extends Node2D

var item_scene: PackedScene = preload("res://tiles/item.tscn")


func recalculate_children(corrector = []):
	var children_count = get_child_count() - corrector.size()
	var counter = 0 
	for child in get_children():
		if child.name not in corrector:
			child.position = Variable.children_position[children_count][counter]
			counter += 1


func item_editor(corrector = []):
	var children_count = get_child_count() - corrector.size()
	var children = get_parent().get_children().map(func(x): return x.name)
	if children_count > 0 and "item_%s" % name not in children:
		var coin = item_scene.instantiate()
		coin.name = "item_%s" % name
		get_parent().add_child(coin)
	elif children_count == 0 and "item_%s" % name in children:
		get_parent().get_node("item_%s" % name).queue_free()


func _on_child_entered_tree(node):
	recalculate_children()
	item_editor()


func _on_child_exiting_tree(node):
	recalculate_children([node.name])
	item_editor([node.name])
