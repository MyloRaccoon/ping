extends Node2D

func _input(event):
	if event.is_action_pressed("ui_accept"):
		OkSound.play()
		$transition.exit()

func _on_transition_exited(_msg):
	get_tree().change_scene_to_file(global.scene_after_control)
