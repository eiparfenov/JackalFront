extends Node2D

var tile_scene: PackedScene = preload("res://tiles/tile.tscn")
var ship_scene: PackedScene = preload("res://tiles/ship.tscn")
var pirate_scene: PackedScene = preload("res://tiles/pirate.tscn")

@onready var pirates_parent = $Pirates
@onready var websocket: Websocket = get_node("/root/WebSocket") 

func _ready():
	websocket.execute_action.connect(_on_websocket_execute_action)
	websocket.add_option.connect(_on_websocket_add_option)
	var field_size = [17, 17]
	var water_range = [2, 2]
	for x in field_size[0]:
		for y in field_size[1]:
			var tile = tile_scene.instantiate()
			add_child(tile)
			tile.name = "tile_%s_%s" % [x - field_size[0] / 2, y - field_size[1] / 2]
			tile.position = Vector2(x - int(field_size[0]) / 2, y - int(field_size[1]) / 2) * 200
			if x < water_range[0] or x >= field_size[0] - water_range[0] or y < water_range[1] or y >= field_size[1] - water_range[1]:
				tile.open_frame(63)
			else:
				tile.open_frame(0)


func _on_websocket_add_option(option: Dictionary):
	pass # Replace with function body.


func _on_websocket_execute_action(action:Dictionary):
	if action["type"] == "spawn_ship" and action["ship_type"] == "simple":
		var ship = ship_scene.instantiate()
		add_child(ship)
		ship.name = action["ship_id"]
		ship.position = Vector2(action["position"]["x"], action["position"]["y"]) * 200
		ship.ship_generation(action["player_owner"])
	elif action["type"] == "spawn_pirate" and action["pirate_type"] == "simple":
		var pirate = pirate_scene.instantiate()
		pirate.name = action["pirate_id"]
		pirate.pirate_generation(action["player_owner"])
		pirate.position = Vector2(action["position"]["x"], action["position"]["y"]) * 200
		get_node("./tile_%s_%s" % [action["position"]["x"], action["position"]["y"]]).add_child(pirate)
