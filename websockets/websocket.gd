extends Node
class_name Websocket

@export var test_mode: bool = true
@export var connect_url: String

signal execute_action(action: Dictionary)
signal add_option(option: Dictionary)
signal game_started(selected_color: int, game_info: Array)

var socket: WebSocketPeer = WebSocketPeer.new()


func select_option(option_id: String):
	socket.send_text(option_id)


func start_game(player_name: String, selected_color: int):
	socket.send_text("%s %s" % [player_name, selected_color])


func test():
	await get_tree().create_timer(3).timeout
	execute_action.emit({
			"for_player": -1,
			"type": "spawn_ship",
			"position": {
				"x": -7,
				"y": 0
			},
			"ship_id": "3",
			"player_owner": 2,
			"ship_type": "simple"
		})
	for i in 3:
		execute_action.emit({
			"for_player": -1,
			"type": "spawn_pirate",
			"position": {
				"x": -7,
				"y": 0
			},
			"pirate_id": "%s" %i,
			"player_owner": 2,
			"pirate_type": "simple"
		})
		
	game_started.emit(
		1,  
		[
		{
		"name": "JackalJackalJackalJackalJackalJackalJackal",
		"color": 0
		},
		{
		"name": "JackalJackalJackalJackalJackalJackalJackal",
		"color": 1
		},
		{
		"name": "JackalJackalJackalJackalJackalJackalJackal",
		"color": 2
		},
		{
		"name": "JackalJackalJackalJackalJackalJackalJackal",
		"color": 3
		}
		]
	)
	add_option.emit(
		{
		"group_id": "not grouped",
		"for_player": 0,
		"id": "000",
		"type": "select_pirate",
		"pirate_id": "0"
		})
	add_option.emit(
		{
		"group_id": "not grouped",
		"for_player": 0,
		"id": "111",
		"type": "select_pirate",
		"pirate_id": "1"
		})
	add_option.emit(
		{
		"group_id": "not grouped",
		"for_player": 0,
		"id": "222",
		"type": "select_pirate",
		"pirate_id": "2"
		})
	add_option.emit(
		{
		"group_id": "not grouped",
		"for_player": 0,
		"id": "555",
		"type": "move_pirate",
		"position": {
		"x": -6,
		"y": 0
		},
		"pirate_id": "1",
		"take_items": []
		})
	await get_tree().create_timer(3).timeout
	execute_action.emit(
		{
		"type": "player_move",
		"current_player": 1
		})
	execute_action.emit(
		{
		"for_player": -1,
		"type": "spawn_item",
		"item_id": "c3ea0061-385d-452c-bc67-fa1c749bc0b2",
		"item_type": "coin",
		"position": {
		"x": -7,
		"y": 0
		}
		})
	execute_action.emit(
		{
		"for_player": -1,
		"type": "spawn_item",
		"item_id": "a3ea0061-385d-452c-bc67-fa1c749bc0b2",
		"item_type": "coin",
		"position": {
		"x": -7,
		"y": 0
		}
		})
	await get_tree().create_timer(3).timeout
	execute_action.emit(
		{
		"for_player": -1,
		"type": "move_item",
		"item_id": "c3ea0061-385d-452c-bc67-fa1c749bc0b2",
		"item_type": "coin",
		"position": {
		"x": -6,
		"y": 0
		}
		})
	add_option.emit(
		{
		"id": "a9b85c30-5914-4d79-8e51-ff8df23747c1",
		"type": "select_items",
		"items_id": [
		"c3ea0061-385d-452c-bc67-fa1c749bc0b2",
		"a3ea0061-385d-452c-bc67-fa1c749bc0b2"
		]
		})


func _ready():
	if test_mode:
		test()
		return
	
	socket.connect_to_url(connect_url)


func _process(delta):
	if test_mode: return
	socket.poll()
	var state = socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			await _process_packet(socket.get_packet().get_string_from_utf8())
	elif state == WebSocketPeer.STATE_CLOSING:
		# Keep polling to achieve proper close.
		pass
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = socket.get_close_code()
		var reason = socket.get_close_reason()
		print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
		set_process(false) # Stop processing.


func _process_packet(packet):
	var response = str_to_var(packet)
	match response:
		{"event_type": "game_started", "color": var color, "players": var players}:
			print("start")
			game_started.emit(int(color), players)
		{"event_type": "game_step", "actions": var actions, "options": var options}:
			for act in actions:
				execute_action.emit(act)
			for opt in options:
				add_option.emit(opt)
