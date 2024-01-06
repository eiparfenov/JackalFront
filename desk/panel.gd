extends Control

@onready var websocket: Websocket = get_node("/root/WebSocket")


var color = ["ffffff", "000000", "ff0000", "ffe600"]


func _ready():
	websocket.game_started.connect(_on_websocket_game_started)
	print(0)


func _on_websocket_game_started(selected_color: int, game_info: Array):
	print(1)
	for i in range(0, len(game_info)):
		var label = Label.new()
		add_child(label)
		label.color = color[game_info[i]["color"]]
		label.text = game_info[i]["player"]
		label.position = Vector2(50, 170 + 50 * i)
		label.z_index = 1
	
