extends Node2D

var everyone_ready = false

# Called when the node enters the scene tree for the first time.
func _input(event):
	
	if event.is_action_pressed("join1"): player_join(1)
	elif event.is_action_pressed("join2"): player_join(2)
	elif event.is_action_pressed("join3"): player_join(3)
	elif event.is_action_pressed("join4"): player_join(4)
	
	elif event.is_action_pressed("start") and everyone_ready:
		GoalSound.play()
		$transition.exit()

func _ready():
	global.players = [false, false, false, false]
	for frame in [$player_frame1, $player_frame2, $player_frame3, $player_frame4]:
		frame.set_ready(false)

func player_join(p):
	OkSound.play()
	var player_frame = get_node("player_frame" + str(p))
	player_frame.activate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var np = global.get_n_player_ready()
	var nf = get_n_frames_active()
	
	var indexs = []
	for i in range(len(global.players)):
		if global.players[i]:
			indexs.append(i)

	if np in [2, 4] and nf == np and indexs != [0,2] and indexs != [1,3]:
		everyone_ready = true
		$ready.show()
		global.n_player = np
	else:
		everyone_ready = false
		$ready.hide()
	global.n_frame_active = get_n_frames_active()

func get_n_frames_active():
	var n = 0
	for frame in [$player_frame1, $player_frame2, $player_frame3, $player_frame4]:
		if frame.active:
			n += 1
	return n


func _on_transition_exited(_msg):
	get_tree().change_scene_to_file("res://scenes/option.tscn")
