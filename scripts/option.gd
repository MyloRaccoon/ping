extends Node2D

func _ready():
	global.scene_after_control = "res://scenes/option.tscn"
	match global.map:
		"none": $menuMenu/mapModifierMenu.select($menuMenu/mapModifierMenu/btn_none)
		"separator": $menuMenu/mapModifierMenu.select($menuMenu/mapModifierMenu/btn_separator)
		"zone": $menuMenu/mapModifierMenu.select($menuMenu/mapModifierMenu/btn_zone)
	if global.timer_active and global.goal_active:
		$menuMenu/finishModMenu.select($menuMenu/finishModMenu/btn_tng)
	elif global.timer_active:
		$menuMenu/finishModMenu.select($menuMenu/finishModMenu/btn_timer)
	elif global.goal_active:
		$menuMenu/finishModMenu.select($menuMenu/finishModMenu/btn_goal)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if global.goal_active:
		$Ngoal.text = str(global.goal)
	if global.timer_active:
		$intTimer.text = str(global.timer)


func _on_play_pressed(btn):
	match btn:
		"local game": 
			GoalSound.play()
			$transition.exit("game")
		"online game": $transition.exit("online")
		"players": $transition.exit("players")
		"controls": $transition.exit("controls")
		"quit": $transition.exit("quit")


func _on_goal_pressed(btn):
	match btn:
		"+":
			if global.goal < 20:
				global.goal += 1
		"-":
			if global.goal > 3:
				global.goal -= 1
		"reset":
			global.goal = 10


func _on_timer_pressed(btn):
	match btn:
		"+":
			if global.timer < 120:
				global.timer += 5
		"-":
			if global.timer > 10:
				global.timer -= 5
		"reset":
			global.timer = 60

func _on_finish_mod_menu_pressed(btn: String):
	match btn:
		"timer and goal": 
			global.timer_active = true
			global.goal_active = true
		"timer":
			global.timer_active = true
			global.goal_active = false
		"goal":
			global.timer_active = false
			global.goal_active = true


func _on_map_modifier_menu_pressed(btn):
	global.map = btn.trim_suffix("     ")


func _on_transition_exited(msg):
	match msg:
		"game": get_tree().change_scene_to_file("res://scenes/game.tscn")
		"online": get_tree().change_scene_to_file("res://scenes/multi_screen.tscn")
		"players": get_tree().change_scene_to_file("res://scenes/player_screen.tscn")
		"controls": get_tree().change_scene_to_file("res://scenes/controls_screen.tscn")
		"quit": get_tree().quit(0)
