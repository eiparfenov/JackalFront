extends Node
class_name Websocket

signal execute_action(action: Dictionary)
signal add_option(option: Dictionary)
signal game_started(selected_color: int, game_info: Array)


func select_option(option_id: String):
	pass


func start_game(player_name: String, selected_color: int):
	print("Start game for player %s colored %s" % [player_name, selected_color])


func test():
	await get_tree().create_timer(3).timeout
	
	execute_action.emit({
		"for_player": -1,
		"type": "spawn_pirate",
		"position": {
			"x": 4,
			"y": 1
		},
		"pirate_id": "1",
		"player_owner": 2,
		"pirate_type": "simple"
	})
	
	'''for i in 3:
		await get_tree().create_timer(1).timeout
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
		})'''
		
	game_started.emit(
		1,  
		[
		{
		"player": "<name>",
		"color": 0
		},
		{
		"player": "<name>",
		"color": 1
		},
		{
		"player": "<name>",
		"color": 2
		},
		{
		"player": "<name>",
		"color": 3
		}
		]
	)
	'''add_option.emit(
		{
		"group_id": "not grouped",
		"for_player": 0,
		"id": "000",
		"type": "select_pirate",
		"pirate_id": "0"
		})'''
	add_option.emit(
		{
		"group_id": "not grouped",
		"for_player": 0,
		"id": "111",
		"type": "select_pirate",
		"pirate_id": "1"
		})
	'''add_option.emit(
		{
		"group_id": "not grouped",
		"for_player": 0,
		"id": "222",
		"type": "select_pirate",
		"pirate_id": "2"
		})'''


func _ready():
	test()

