extends Node2D

func _on_btnPlay_pressed():
	loader.goto_scene("res://scenes/level.tscn")


func _on_multiplayer_pressed():
	get_tree().change_scene("res://Scena1.tscn");


func _on_sigleplayer_pressed():
	get_tree().change_scene("res://scenes/level.tscn");


func _on_help_pressed():
	get_tree().change_scene("res://scenes/ScenaHelp.tscn");
