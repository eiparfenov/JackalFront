extends Node

@export var connection_string: String
var socket = WebSocketPeer.new()

func _ready() -> void:
	socket.connect_to_url(connection_string)

func _process(delta: float) -> void:
	socket.poll()
	var state = socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			print("Packet: ", socket.get_packet().get_string_from_utf8())
	elif state == WebSocketPeer.STATE_CLOSING:
		# Keep polling to achieve proper close.
		pass
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = socket.get_close_code()
		var reason = socket.get_close_reason()
		print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
		set_process(false) # Stop processing.
