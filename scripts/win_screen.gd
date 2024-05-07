extends Node2D

func _ready():
	if global.get_n_player_ready() < 3:
		$Label.text = "PLAYER " + global.winner + " WON !"
	else:
		match global.winner:
			"1": $Label.text = "BLUE TEAM WON !"
			"2": $Label.text = "RED TEAM WON !"

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://scenes/option.tscn")
