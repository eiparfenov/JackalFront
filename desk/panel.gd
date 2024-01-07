extends Control

@onready var websocket: Websocket = get_node("/root/WebSocket")

var color = ["ffffff", "000000", "ff0000", "ffe600"]


func _ready():
	websocket.game_started.connect(_on_websocket_game_started)
	websocket.add_option.connect(_on_websocket_add_option)


func _on_websocket_game_started(selected_color: int, game_info: Array):
	var player_labels = Control.new()
	player_labels.name = "PlayerLabels"
	add_child(player_labels)
	for i in range(0, len(game_info)):
		var nickname_label = Label.new()
		$PlayerLabels.add_child(nickname_label)
		nickname_label.modulate = color[game_info[i]["color"]]
		nickname_label.text = game_info[i]["player"]
		nickname_label.name = "player_%s" % game_info[i]["color"]
		nickname_label.position = Vector2(50, 170 + 50 * i)
		nickname_label.z_index = 1
		nickname_label.size = Vector2(200, 30)
		var money_label = Label.new()
		$PlayerLabels.add_child(money_label)
		money_label.text = "x0"
		money_label.name = "money_%s" % game_info[i]["color"]
		money_label.z_index = 1
		money_label.position = Vector2(600, 170 + 50 * i)
		var rum_label = Label.new()
		$PlayerLabels.add_child(rum_label)
		rum_label.text = "x0"
		rum_label.name = "rum_%s" % game_info[i]["color"]
		rum_label.z_index = 1
		rum_label.position = Vector2(800, 170 + 50 * i)

var pirate_button = 0
func _on_websocket_add_option(option: Dictionary):
	if option["type"] == "select_pirate":
		pirate_button += 1
		var pirate = get_parent().get_parent().find_child(option["pirate_id"], true, false)
		var button = Button.new()
		$PirateChooser.add_child(button)
		button.modulate = "00ff00"
		button.position = Vector2(pirate_button * 200, 500)
		button.z_index = 1
		button.size = Vector2(100, 100)
		button.name = option["id"]
		button.pressed.connect(_on_pirate_button_pressed.bind(String(button.name), pirate))
		button.mouse_entered.connect(_on_pirate_button_entered.bind(String(button.name), pirate))
		button.mouse_exited.connect(_on_pirate_button_exited.bind(String(button.name), pirate))


var condition: int = 0
var zoom = [1, 1.5]
func _on_pirate_button_pressed(id, pirate):
	var button = $PirateChooser.get_node(id)
	condition += 1
	for other_button in $PirateChooser.get_children():
		if other_button != button:
			other_button.disabled = condition % 2
			pirate.scale = Vector2(zoom[condition % 2], zoom[condition % 2])


func _on_pirate_button_entered(id, pirate):
	var button = $PirateChooser.get_node(id)
	if button.disabled == false:
		pirate.scale = Vector2(zoom[1], zoom[1])


func _on_pirate_button_exited(id, pirate):
	var button = $PirateChooser.get_node(id)
	if condition % 2 == 0:
		pirate.scale = Vector2(zoom[0], zoom[0])
