extends Node2D

func _input(event):
	if event is InputEventKey:
		OkSound.play()
		get_tree().change_scene_to_file("res://scenes/controls_screen.tscn")

