extends Control

var waiting_menu_scene = preload("res://desk/world.tscn")

@onready var nick_name_text_edit = $NickNameTextEdit
@onready var color_select = $ColorSelect
@onready var websocket: Websocket = get_node("/root/WebSocket")

func _on_button_pressed():
	var nick_name = nick_name_text_edit.text
	if nick_name == "":
		return
	var selected: PackedInt32Array = color_select.get_selected_items()
	if selected.is_empty():
		return
	var selected_color = selected[0]
	websocket.start_game(nick_name, selected_color)
	get_tree().change_scene_to_packed(waiting_menu_scene)
	
