extends Node2D

func _input(event):
	if event.is_action_pressed("ui_accept"):
		OkSound.play()
		get_tree().change_scene_to_file("res://scenes/controls_screen.tscn")
