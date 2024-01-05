extends Control
@onready var websocket: Websocket = get_node("/root/WebSocket")


func _ready():
	websocket.game_started.connect(_on_game_started)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_game_started(players: Array[String]):
	print(players)
