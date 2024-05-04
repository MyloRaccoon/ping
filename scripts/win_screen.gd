extends Node2D

func _ready():
	$Label.text = "PLAYER " + global.winner + " WON !"

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://scenes/option.tscn")
