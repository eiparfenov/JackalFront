extends Node
class_name Websocket

@export var test_mode: bool = true
@export var connect_url: String

signal execute_action(action: Dictionary)
signal add_option(option: Dictionary)
signal game_started(selected_color: int, game_info: Dictionary)

var socket: WebSocketPeer = WebSocketPeer.new()


func select_option(option_id: String):
	pass


func start_game(player_name: String, selected_color: int):
	socket.send_text("%s %s" % [player_name, selected_color])


func test():
	await get_tree().create_timer(2).timeout
	execute_action.emit({
		"for_player": -1,
		"type": "spawn_ship",
		"position": {
			"x": -7,
			"y": 0
		},
		"ship_id": "44738c84-0476-43ad-91a4-d5574fy2fd6c",
		"player_owner": 2,
		"ship_type": "simple"
	})
	await get_tree().create_timer(2).timeout
	execute_action.emit({
		"for_player": -1,
		"type": "spawn_ship",
		"position": {
			"x": 0,
			"y": 7
		},
		"ship_id": "83338c84-0476-43ad-91a4-d5574fb2fd6c",
		"player_owner": 1,
		"ship_type": "simple"
	})
	await get_tree().create_timer(2).timeout
	execute_action.emit({
		"for_player": -1,
		"type": "spawn_ship",
		"position": {
			"x": 0,
			"y": -7
		},
		"ship_id": "83338c84-0476-42gd-91a4-d5574fb2fd6c",
		"player_owner": 0,
		"ship_type": "simple"
	})
	await get_tree().create_timer(2).timeout
	execute_action.emit({
		"for_player": -1,
		"type": "spawn_ship",
		"position": {
			"x": 7,
			"y": 0
		},
		"ship_id": "83338c84-0896-43ad-91a4-d5574fb2fd6c",
		"player_owner": 3,
		"ship_type": "simple"
	})
	execute_action.emit({
		"type": "ready_to_start"
	})
	execute_action.emit({
		"type": "move_ship",
		"position": {
			"x": 7,
			"y": 3
		},
		"ship_id": "83338c84-0896-43ad-91a4-d5574fb2fd6c"
	})
	
	for i in 16:
		#await get_tree().create_timer(1).timeout
		execute_action.emit({
			"for_player": -1,
			"type": "spawn_pirate",
			"position": {
				"x": 0,
				"y": 7
			},
			"pirate_id": "%s" %i,
			"player_owner": 1,
			"pirate_type": "simple"
		})
		execute_action.emit({
			"for_player": -1,
			"type": "open_card",
			"position": {
				"x": 6,
				"y": 0
			},
			"rotation": 0,
			"frame": 40
		})
	for i in 16:
		await get_tree().create_timer(1).timeout
		execute_action.emit({
			"type": "move_pirate",
			"position": {
				"x": 1,
				"y": 7
			},
			"pirate_id": "%s" % i
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
			_process_packet(socket.get_packet().get_string_from_utf8())
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
			game_started.emit(color, players)
		{"event_type": "game_step", "actions": var actions, "options": var options}:
			for opt in options:
				print(opt)
			for act in actions:
				print(act)	
			
