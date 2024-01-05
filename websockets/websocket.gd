extends Node
class_name Websocket

signal execute_action(action: Dictionary)
signal add_option(option: Dictionary)
signal game_started(game_info: Array[String])


func select_option(option_id: String):
	pass


func start_game(player_name: String, selected_color: int):
	print("Start game for player %s colored %s" % [player_name, selected_color])


func test():
	await get_tree().create_timer(2).timeout
	execute_action.emit({
		"for_player": -1,
		"type": "spawn_ship",
		"position": {
			"x": -7,
			"y": 0
		},
		"ship_id": "83738c84-0476-43ad-91a4-d5574fb2fd6c",
		"player_owner": 0,
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
		"type": "spawn_pirate",
		"position": {
			"x": 0,
			"y": 7
		},
		"pirate_id": "83338b84-0476-43ad-91a4-d5574fb2fd6c",
		"player_owner": 1,
		"pirate_type": "simple"
	})
	await get_tree().create_timer(2).timeout
	execute_action.emit({
		"for_player": -1,
		"type": "spawn_pirate",
		"position": {
			"x": 0,
			"y": 7
		},
		"pirate_id": "83338a84-0476-43ad-91a4-d5574fb2fd6c",
		"player_owner": 1,
		"pirate_type": "simple"
	})

func _ready():
	test()