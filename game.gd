extends Node2D

var pts1 = 0
var pts2 = 0

var ball_tscn = preload("res://ball.tscn")
var ball 

var player1_in_ballZone = false
var player2_in_ballZone = false

var prolong = false

var pausing = false

var pause_time_left
var stock_pos_p1
var stock_pos_p2
var stock_pos_ball

func new_ball(ball_pos, p1_pos, p2_pos):
	$Player.position = p1_pos
	$Player2.position = p2_pos
	ball = ball_tscn.instantiate()
	ball.position = ball_pos
	call_deferred("add_child", ball)

func _ready():
	$firstTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		if !pausing and global.playing:
			pause()
		elif pausing:
			resume()
			
	if int($firstTimer.time_left) == 0:
		$firstTimerLB.text = "GO"
	else:
		$firstTimerLB.text = str(int($firstTimer.time_left))
	
	
	if pausing:
		$timerLB.text = str(int(pause_time_left))
	else:
		$timerLB.text = str(int($Timer.time_left))
		if prolong:
			$timerLB.text = "Prolongation !"
	$pts1.text = str(pts1)
	$pts2.text = str(pts2)

func _on_goal_1_body_entered(body):
	if body in get_tree().get_nodes_in_group("ball"):
		if prolong:
			call_deferred("win", "2")
		else:
			pts2 += 1
			if pts2 == global.goal and global.goal_active:
				call_deferred("win", "2")
			else:
				ball.queue_free()
				new_ball($ballSpawnPoint.position, $p1SpawnPoint.position, $p2SpawnPoint.position)
		
func _on_goal_2_body_entered(body):
	if body in get_tree().get_nodes_in_group("ball"):
		if prolong:
			call_deferred("win", "1")
		else:
			pts1 += 1
			if pts1 == global.goal and global.goal_active:
				call_deferred("win", "1")
			else:
				ball.queue_free()
				new_ball($ballSpawnPoint.position, $p1SpawnPoint.position, $p2SpawnPoint.position)

func win(winner):
	match winner:
		'1' : get_tree().change_scene_to_file("res://win_screen1.tscn")
		'2' : get_tree().change_scene_to_file("res://win_screen_2.tscn")


func _on_timer_timeout():
	if pts1 == pts2:
		prolong = true
	elif pts1 < pts2:
		win('2')
	elif pts1 > pts2:
		win("1")


func _on_first_timer_timeout():
	if global.timer_active:
		$Timer.start(global.timer)
		$timerLB.show()
	else:
		$timerLB.hide()
	$pts1.show()
	$pts2.show()
	$firstTimerLB.hide()
	global.playing = true
	new_ball($ballSpawnPoint.position, $p1SpawnPoint.position, $p2SpawnPoint.position)

func pause():
	pause_time_left = $Timer.time_left
	stock_pos_ball = $ball.position
	stock_pos_p1 = $Player.position
	stock_pos_p2 = $Player2.position
	$Timer.stop()
	pausing = true
	$PauseMenu.show()
	global.playing = false
	ball.queue_free()

func resume():
	$Timer.start(pause_time_left)
	pausing = false
	$PauseMenu.hide()
	global.playing = true
	new_ball(stock_pos_ball, stock_pos_p1, stock_pos_p2)

func _on_resume_pressed():
	resume()

func _on_quit_to_menu_pressed():
	get_tree().change_scene_to_file("res://option.tscn")
