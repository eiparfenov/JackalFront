extends Control

@onready var websocket: Websocket = get_node("/root/WebSocket")

var money_scene: PackedScene = preload("res://tiles/money.tscn")
var color = ["ffffff", "000000", "ff0000", "ffe600"]


func _ready():
	websocket.game_started.connect(_on_websocket_game_started)
	websocket.add_option.connect(_on_websocket_add_option)
	websocket.execute_action.connect(_on_websocket_execute_action)


func _on_websocket_game_started(selected_color: int, game_info: Array):
	var player_labels = Control.new()
	player_labels.name = "PlayerLabels"
	add_child(player_labels)
	for i in range(0, len(game_info)):
		var nickname_label = Label.new()
		$PlayerLabels.add_child(nickname_label)
		nickname_label.modulate = color[int(game_info[i]["color"])]
		nickname_label.text = game_info[i]["name"]
		nickname_label.name = "player_%s" % game_info[i]["color"]
		nickname_label.position = Vector2(50, 170 + 50 * i)
		nickname_label.z_index = 1
		nickname_label.size = Vector2(200, 30)
		var money_label = Label.new()
		$PlayerLabels.add_child(money_label)
		money_label.text = "x 0"
		money_label.name = "money_label_%s" % game_info[i]["color"]
		money_label.z_index = 1
		money_label.position = Vector2(600, 170 + 50 * i)
		var money_icon = money_scene.instantiate()
		$PlayerLabels.add_child(money_icon)
		money_icon.name = "money_icon_%s" % game_info[i]["color"]
		money_icon.z_index = 1
		money_icon.position = Vector2(560, 185 + 50 * i)
		var rum_label = Label.new()
		$PlayerLabels.add_child(rum_label)
		rum_label.text = "x 0"
		rum_label.name = "rum_label_%s" % game_info[i]["color"]
		rum_label.z_index = 1
		rum_label.position = Vector2(800, 170 + 50 * i)
		var rum_icon = money_scene.instantiate()
		$PlayerLabels.add_child(rum_icon)
		rum_icon.name = "rum_icon_%s" % game_info[i]["color"]
		rum_icon.z_index = 1
		rum_icon.position = Vector2(760, 185 + 50 * i)


func _on_websocket_execute_action(action: Dictionary):
	if action["type"] == "player_move":
		pirate_button = 0
		for button in $PirateChooser.get_children():
			button.queue_free()


var pirate_button = 0
var items_button = 0
func _on_websocket_add_option(option: Dictionary):
	if option["type"] == "select_pirate":
		pirate_button += 1
		var pirate = [get_parent().get_parent().find_child(option["pirate_id"], true, false)]
		var button = Button.new()
		$PirateChooser.add_child(button)
		button.modulate = "00ff00"
		button.position = Vector2(pirate_button * 200, 500)
		button.z_index = 1
		button.size = Vector2(100, 100)
		button.name = option["id"]
		button.pressed.connect(_on_object_button_pressed.bind(pirate, option["id"], "PirateChooser"))
		button.mouse_entered.connect(_on_object_button_entered.bind(pirate))
		button.mouse_exited.connect(_on_object_button_exited.bind(pirate))
	elif option["type"] == "select_items":
		items_button += 1
		var taken_items = option["items_id"]
		var button = Button.new()
		var items = []
		for item in taken_items:
			items.append(get_parent().get_parent().find_child("item_%s" % get_parent().get_parent().find_child(item, true, false).get_parent().name, true, false))
		$ItemChooser.add_child(button)
		button.modulate = "00ff00"
		button.position = Vector2(items_button * 200, 650)
		button.z_index = 1
		button.size = Vector2(100, 100)
		button.name = option["id"]
		button.pressed.connect(_on_object_button_pressed.bind(items, option["id"], "ItemChooser"))
		button.mouse_entered.connect(_on_object_button_entered.bind(items))
		button.mouse_exited.connect(_on_object_button_exited.bind(items))
		

var zoom = [1, 1.5]
func _on_object_button_pressed(objects, id, path):
	for button in get_node(path).get_children():
		button.visible = false
	for object in objects:
		object.scale = Vector2(zoom[1], zoom[1])
	websocket.select_option(id)


func _on_object_button_entered(objects):
	for object in objects:
		object.scale = Vector2(zoom[1], zoom[1])


func _on_object_button_exited(objects):
	for object in objects:
		object.scale = Vector2(zoom[0], zoom[0])
