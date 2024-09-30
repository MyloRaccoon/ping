extends Node2D

var pts1 = 0
var pts2 = 0

var player1_in_ballZone = false
var player2_in_ballZone = false

var prolong = false

var pausing = false

var pause_time_left
var stock_ball_velocity

func new_ball(ball_pos, p1_pos = $players/p1SpawnPoint.position, p2_pos = $players/p2SpawnPoint.position, p3_pos = $players/p3SpawnPoint.position, p4_pos = $players/p4SpawnPoint.position):
	$players/Player.position = p1_pos
	$players/Player2.position = p2_pos
	$players/Player3.position = p3_pos
	$players/Player4.position = p4_pos
	$ball.sleeping = true
	$ball.position = ball_pos
	$ball.sleeping = false

func _ready():
	$pts1.label_settings.set_font_color(global.blue_team_color)
	$pts2.label_settings.set_font_color(global.red_team_color)
	global.playing = false
	$PauseMenu/menu.activate(false)
	$Timers/firstTimer.start()
	$separator.hide()
	$goal1/p1Zone.hide()
	$goal2/p2Zone.hide()
	if global.map == "separator":
		$separator.show()
	if global.map == "zone":
		$goal1/p1Zone.show()
		$goal2/p2Zone.show()
	$separator/collisionbox.disabled = !(global.map == "separator")
	$goal1/p1Zone/CollisionShape2D.disabled = !(global.map == "zone")
	$goal2/p2Zone/CollisionShape2D.disabled = !(global.map == "zone")

func distance_between_points(point1: Vector2, point2: Vector2):
	return sqrt((point2.x - point1.x)**2 + (point2.y - point1.y)**2)

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		if !pausing and global.playing:
			pause()
		elif pausing:
			resume()
			
	if int($Timers/firstTimer.time_left) == 0:
		$Timers/firstTimerLB.text = "GO"
	else:
		$Timers/firstTimerLB.text = str(int($Timers/firstTimer.time_left))
	
	if int($Timers/Timer.time_left) <= 3:
		$Timers/timerLB.label_settings.set_font_color(Color(.68, .39, 0))
	else:
		$Timers/timerLB.label_settings.set_font_color(Color(1, 1, 1))
	
	if pausing:
		$Timers/timerLB.text = str(int(pause_time_left))
	else:
		$Timers/timerLB.text = str(int($Timers/Timer.time_left))
		if prolong:
			$Timers/timerLB.label_settings.set_font_color(Color(1, 1, 1))
			$Timers/timerLB.text = "Prolongation !"
	$pts1.text = str(pts1)
	$pts2.text = str(pts2)
	
	if distance_between_points($middleBallSpawnPoint.position, $ball.position) > 1000:
		print(true)
		new_ball($middleBallSpawnPoint.position)

func _on_goal_1_body_entered(body):
	if body in get_tree().get_nodes_in_group("ball"):
		GoalSound.play()
		if prolong:
			call_deferred("win", "2")
		else:
			pts2 += 1
			if pts2 == global.goal and global.goal_active:
				call_deferred("win", "2")
			else:
				call_deferred("new_ball", $p1BallSpawnPoint.position)
		
func _on_goal_2_body_entered(body):
	if body in get_tree().get_nodes_in_group("ball"):
		GoalSound.play()
		if prolong:
			call_deferred("win", "1")
		else:
			pts1 += 1
			if pts1 == global.goal and global.goal_active:
				call_deferred("win", "1")
			else:
				call_deferred("new_ball", $p2BallSpawnPoint.position)

func win(winner):
	global.winner = winner
	$transition.exit("win")

func _on_timer_timeout():
	if pts1 == pts2:
		prolong = true
	elif pts1 < pts2:
		win('2')
	elif pts1 > pts2:
		win("1")


func _on_first_timer_timeout():
	if global.timer_active:
		$Timers/Timer.start(global.timer)
		$Timers/timerLB.show()
	else:
		$Timers/timerLB.hide()
	$pts1.show()
	$pts2.show()
	$Timers/firstTimerLB.hide()
	global.playing = true
	new_ball($middleBallSpawnPoint.position)

func pause():
	pause_time_left = $Timers/Timer.time_left
	stock_ball_velocity = $ball.linear_velocity
	$Timers/Timer.stop()
	pausing = true
	$PauseMenu.show()
	$PauseMenu/menu.activate(true)
	global.playing = false
	$ball.sleeping = true

func resume():
	$Timers/Timer.start(pause_time_left)
	pausing = false
	$PauseMenu.hide()
	global.playing = true
	$ball.sleeping = false
	$ball.linear_velocity = stock_ball_velocity
	$PauseMenu/menu.activate(false)

func _on_menu_pressed(btn):
	match btn:
		"resume": resume()
		"quit":
			$PauseMenu.queue_free()
			$transition.exit("option")


func _on_transition_exited(msg):
	match msg:
		"option": get_tree().change_scene_to_file("res://scenes/option.tscn")
		"win": get_tree().change_scene_to_file("res://scenes/win_screen.tscn")
