extends Node2D

func _ready():
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
		"play": $transition.exit("game")
		"players": $transition.exit("players")
		"quit": get_tree().quit(0)


func _on_goal_pressed(btn):
	match btn:
		"plus":
			if global.goal < 20:
				global.goal += 1
		"minus":
			if global.goal > 3:
				global.goal -= 1
		"reset":
			global.goal = 10


func _on_timer_pressed(btn):
	match btn:
		"plus":
			if global.timer < 120:
				global.timer += 5
		"minus":
			if global.timer > 10:
				global.timer -= 5
		"reset":
			global.timer = 60

func _on_finish_mod_menu_pressed(btn):
	match btn:
		"tng": 
			global.timer_active = true
			global.goal_active = true
		"timer":
			global.timer_active = true
			global.goal_active = false
		"goal":
			global.timer_active = false
			global.goal_active = true


func _on_map_modifier_menu_pressed(btn):
	global.map = btn


func _on_transition_exited(msg):
	match msg:
		"game": get_tree().change_scene_to_file("res://scenes/game.tscn")
		"players": get_tree().change_scene_to_file("res://scenes/player_screen.tscn")
