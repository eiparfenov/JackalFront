extends Node2D

var tile_scene: PackedScene = preload("res://tiles/tile.tscn")
var ship_scene: PackedScene = preload("res://tiles/ship.tscn")
var pirate_scene: PackedScene = preload("res://tiles/pirate.tscn")
var item_scene: PackedScene = preload("res://tiles/item.tscn")
var node_scene: PackedScene = preload("res://desk/node.tscn")

@onready var websocket: Websocket = get_node("/root/WebSocket") 


func _ready():
	websocket.execute_action.connect(_on_websocket_execute_action)
	websocket.add_option.connect(_on_websocket_add_option)
	var tilefield = Node2D.new()
	tilefield.name = "TileField"
	add_child(tilefield)
	var field_size = [17, 17]
	var water_range = [2, 2]
	for x in field_size[0]:
		for y in field_size[1]:
			var tile = tile_scene.instantiate()
			$TileField.add_child(tile)
			tile.name = "tile_%s_%s" % [x - field_size[0] / 2, y - field_size[1] / 2]
			tile.position = Vector2(x - int(field_size[0]) / 2, y - int(field_size[1]) / 2) * 200
			if x < water_range[0] or x >= field_size[0] - water_range[0] or y < water_range[1] or y >= field_size[1] - water_range[1]:
				tile.open_frame(63)
			else:
				tile.open_frame(0)
			var coin_node = node_scene.instantiate()
			coin_node.name = "coin_%s_%s" % [x - field_size[0] / 2, y - field_size[1] / 2]
			tile.add_child(coin_node)


func _on_websocket_execute_action(action: Dictionary):
	if action["type"] == "spawn_ship" and action["ship_type"] == "simple":
		var ship = ship_scene.instantiate()
		add_child(ship)
		ship.name = action["ship_id"]
		ship.position = Vector2(action["position"]["x"], action["position"]["y"]) * 200
		ship.ship_generation(action["player_owner"])
	elif action["type"] == "spawn_pirate" and action["pirate_type"] == "simple":
		var pirate = pirate_scene.instantiate()
		var tile = get_node("./TileField/tile_%s_%s" % [action["position"]["x"], action["position"]["y"]])
		pirate.name = action["pirate_id"]
		pirate.pirate_generation(action["player_owner"])
		pirate.position = Vector2(action["position"]["x"], action["position"]["y"]) * 200
		tile.add_child(pirate)
	elif action["type"] == "move_ship":
		var ship = get_node("./%s" % action["ship_id"])
		ship.position = Vector2(action["position"]["x"], action["position"]["y"]) * 200
	elif action["type"] == "move_pirate":
		var pirate = find_child(action["pirate_id"], true, false)
		var old_tile = pirate.get_parent()
		var new_tile = get_node("./TileField/tile_%s_%s" % [action["position"]["x"], action["position"]["y"]])
		pirate.position = Vector2(action["position"]["x"], action["position"]["y"]) * 200
		old_tile.remove_child(pirate)
		new_tile.add_child(pirate)
		pirate.scale = Vector2(1, 1)
		for tile in $TileField.get_children():
			for elem in tile.get_children():
				if elem is Area2D:
					elem.queue_free()
	elif action["type"] == "player_move":
		for tile in $TileField.get_children():
			for elem in tile.get_children():
				if elem is Area2D:
					elem.queue_free()
	elif action["type"] == "open_card":
		var tile = get_node("./TileField/tile_%s_%s" % [action["position"]["x"], action["position"]["y"]])
		tile.open_frame(action["frame"], action["rotation"])
	elif action["type"] == "spawn_item" and action["item_type"] == "coin":
		var coin = Node2D.new()
		var coin_node = get_node("./TileField/tile_%s_%s/coin_%s_%s" % [action["position"]["x"], action["position"]["y"], action["position"]["x"], action["position"]["y"]])
		coin.name = action["item_id"]
		coin.position = Vector2(action["position"]["x"], action["position"]["y"]) * 200
		coin_node.add_child(coin)
	elif action["type"] == "move_item" and action["item_type"] == "coin":
		var coin = find_child(action["item_id"], true, false)
		var old_node = coin.get_parent()
		var new_node = get_node("./TileField/tile_%s_%s/coin_%s_%s" % [action["position"]["x"], action["position"]["y"], action["position"]["x"], action["position"]["y"]])
		coin.position = Vector2(action["position"]["x"], action["position"]["y"]) * 200
		old_node.remove_child(coin)
		new_node.add_child(coin)
	elif action["type"] == "remove_item" and action["item_type"] == "coin":
		var coin = find_child(action["item_id"], true, false)
		var old_node = coin.get_parent()
		old_node.remove_child(coin)
	elif action["type"] == "ready_to_start":
		$UI/WaitingFiller.visible = false


func _on_websocket_add_option(option: Dictionary):
	if option["type"] == "move_pirate":
		var pirate = find_child(option["pirate_id"], true, false)
		var old_tile = pirate.get_parent()
		var available_tile = get_node("./TileField/tile_%s_%s" % [option["position"]["x"], option["position"]["y"]])
		var area = Area2D.new()
		area.name = "area_%s_%s" % [option["position"]["x"], option["position"]["y"]]
		available_tile.add_child(area)
		area.input_event.connect(func(node, event, shape_idx): _on_mouse_is_pressed(available_tile, event, option["id"]))
		var shape = CollisionShape2D.new()
		shape.name = "shape_%s_%s" % [option["position"]["x"], option["position"]["y"]]
		area.add_child(shape)
		shape.shape = RectangleShape2D.new()
		shape.shape.size = Vector2(200, 200)


func _on_mouse_is_pressed(tile, event, id):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		websocket.select_option(id)
