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
var stock_ball_velocity

func new_ball(ball_pos, p1_pos, p2_pos):
	$players/Player.position = p1_pos
	$players/Player2.position = p2_pos
	ball = ball_tscn.instantiate()
	ball.position = ball_pos
	call_deferred("add_child", ball)

func _ready():
	$PauseMenu/menu.activate(false)
	$UI/firstTimer.start()
	$map/separator.hide()
	$goal1/p1Zone.hide()
	$goal2/p2Zone.hide()
	if global.map == "separator":
		$map/separator.show()
	if global.map == "zone":
		$goal1/p1Zone.show()
		$goal2/p2Zone.show()
	$map/separator/collisionbox.disabled = !(global.map == "separator")
	$goal1/p1Zone/CollisionShape2D.disabled = !(global.map == "zone")
	$goal2/p2Zone/CollisionShape2D.disabled = !(global.map == "zone")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		if !pausing and global.playing:
			pause()
		elif pausing:
			resume()
			
	if int($UI/firstTimer.time_left) == 0:
		$UI/firstTimerLB.text = "GO"
	else:
		$UI/firstTimerLB.text = str(int($UI/firstTimer.time_left))
	
	
	if pausing:
		$UI/timerLB.text = str(int(pause_time_left))
	else:
		$UI/timerLB.text = str(int($UI/Timer.time_left))
		if prolong:
			$UI/timerLB.text = "Prolongation !"
	$UI/pts1.text = str(pts1)
	$UI/pts2.text = str(pts2)

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
				new_ball($p1BallSpawnPoint.position, $players/p1SpawnPoint.position, $players/p2SpawnPoint.position)
		
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
				new_ball($p2BallSpawnPoint.position, $players/p1SpawnPoint.position, $players/p2SpawnPoint.position)

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
		$UI/Timer.start(global.timer)
		$UI/timerLB.show()
	else:
		$UI/timerLB.hide()
	$UI/pts1.show()
	$UI/pts2.show()
	$UI/firstTimerLB.hide()
	global.playing = true
	new_ball($middleBallSpawnPoint.position, $players/p1SpawnPoint.position, $players/p2SpawnPoint.position)

func pause():
	pause_time_left = $UI/Timer.time_left
	stock_ball_velocity = ball.linear_velocity
	$UI/Timer.stop()
	pausing = true
	$PauseMenu.show()
	$PauseMenu/menu.activate(true)
	global.playing = false
	ball.linear_velocity = Vector2(0,0)

func resume():
	$UI/Timer.start(pause_time_left)
	pausing = false
	$PauseMenu.hide()
	global.playing = true
	ball.linear_velocity = stock_ball_velocity
	$PauseMenu/menu.activate(false)

func _on_menu_pressed(btn):
	match btn:
		"resume": resume()
		"quit": get_tree().change_scene_to_file("res://option.tscn")
