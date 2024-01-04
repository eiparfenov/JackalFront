extends Node
class_name WebsocketWorker

@export var connection_string: String
var _socket = WebSocketPeer.new()

signal action_received(action: Dictionary)
signal option_received(options : Dictionary)

func _ready() -> void:
	_socket.connect_to_url(connection_string)
	await get_tree().create_timer(1).timeout
	_socket.send_text("Endy")
	

func _process(delta: float) -> void:
	_socket.poll()
	var state = _socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		while _socket.get_available_packet_count():
			pass
	elif state == WebSocketPeer.STATE_CLOSING:
		# Keep polling to achieve proper close.
		pass
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = _socket.get_close_code()
		var reason = _socket.get_close_reason()
		print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
		set_process(false) # Stop processing.



