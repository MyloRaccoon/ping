extends Node2D

# Called when the node enters the scene tree for the first time.
func _input(event):
	if "joypad" in event.as_text():
		if global.players[event.device] or event.is_action_pressed("join"+str(event.device)):
			player_join(event.device)

	elif event.is_action_pressed("down1"): player_join(1)
	elif event.is_action_pressed("down2"): player_join(2)
	elif event.is_action_pressed("down3"): player_join(3)
	elif event.is_action_pressed("down4"): player_join(4)

func player_join(p):
	var player_frame = get_node("player_frame" + str(p))
	player_frame.activate()
	if player_frame.active:
		player_frame.show()
	else:
		player_frame.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
