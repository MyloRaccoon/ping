extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if global.goal_active and global.timer_active:
		$ModMenu.select(0)
	elif global.timer_active:
		$ModMenu.select(1)
	elif global.goal_active:
		$ModMenu.select(2)
	update_control()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if global.goal_active:
		$Ngoal.text = str(global.goal)
	if global.timer_active:
		$intTimer.text = str(global.timer)


func _on_btn_quit_pressed():
	get_tree().quit(0)


func _on_mod_menu_item_selected(index):
	global.timer_active = index in [0,1]
	global.goal_active = index in [0,2]
	update_control()

func update_control():
	for control in get_tree().get_nodes_in_group("timerControl"):
			if global.timer_active:
				control.show()
			else:
				control.hide()
	for control in get_tree().get_nodes_in_group("goalControl"):
			if global.goal_active:
				control.show()
			else:
				control.hide()


func _on_goalP_pressed():
	if global.goal < 20:
		global.goal += 1

func _on_goalM_pressed():
	if global.goal > 3:
		global.goal -= 1

func _on_goal_r_pressed():
	global.goal = 10

func _on_timerP_pressed():
	if global.timer < 120:
		global.timer += 5

func _on_timerM_pressed():
	if global.timer > 10:
		global.timer -= 5

func _on_timer_r_pressed():
	global.timer = 60


func _on_btn_play_pressed():
	get_tree().change_scene_to_file("res://game.tscn")
