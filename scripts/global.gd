extends Node

const blue_team_color = Color("#4664eb")
const red_team_color = Color("#d22d23")
const skins = [Color(1, 1, 1), Color(0, 0, 0), Color(1, 0, 0), Color(0, 1, 0), Color(0, 0, 1), Color(1, 1, 0), Color(1, 0, 1), Color(0, 1, 1)]
var player_skin = [4, 2, 0, 1]
var players = [true, true, false, false]

var n_player = 2
var n_frame_active

var scene_after_control = "res://scenes/player_screen.tscn"

func get_n_player_ready():
	var n = 0
	for is_ready in players:
		if is_ready:
			n += 1
	return n

func color_taken(color : int, player : int):
	var taken = false
	var i = 0
	while i < len(player_skin) and not taken:
		if player_skin[i] == color and i != player and players[i]:
			print("-----")
			print("player "+str(player)+" tried color "+str(color))
			print("player "+str(i)+" took it")
			print("player"+str(i)+"active : " + str(players[i]))
			print("player_skin[i] = color : " + str(player_skin[i]==color))
			print("i != player : " + str(i!=player))
			taken = true
		i+=1
	return taken

var timer : int = 60
var goal : int = 10

var timer_active : bool = true
var goal_active : bool = true

var map : String = "none"

var playing : bool = false

var last_ball_velocity

var winner
