extends Control

@onready var websocket: Websocket = get_node("/root/WebSocket")


var color = ["ffffff", "000000", "ff0000", "ffe600"]


func _ready():
	websocket.game_started.connect(_on_websocket_game_started)
	websocket.add_option.connect(_on_websocket_add_option)
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
		label.size = Vector2(200, 30)


func _on_websocket_add_option(option: Dictionary):
	if option["type"] == "select_pirate":
		var pirate = find_child(option["pirate_id"], true, false)
		var tile = pirate.get_parent()
		var button = Button.new()
		add_child(button)
		button.color = "0000ff"
		button.position = Vector2(50, 500)
		button.z_index = 1
		button.size = Vector2(100, 100)
		
