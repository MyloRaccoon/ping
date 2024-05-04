extends Node

var timer : int = 60
var goal : int = 10

var timer_active : bool = true
var goal_active : bool = true

var map : String = "none"

var playing : bool = false

var last_ball_velocity

func create_button(x, y, label):
	var btn = preload("res://scenes/button.tscn").instantiate()
	btn.position.x = x
	btn.position.y = y
	btn.label = label
	return btn

var winner
