extends Control

var start_menu_scene = preload("res://menu/start_menu.tscn")

func _on_button_pressed():
	get_tree().change_scene_to_packed(start_menu_scene)
