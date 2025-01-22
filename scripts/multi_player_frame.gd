extends Node2D

@onready var outline = $active/outline
@onready var lbl_name = $active/name
@onready var lbl_ready = $active/lbl_ready
@onready var sprite = $active/Sprite2D
@onready var cross = $active/cross

@export var player_name: String

@export var index : int

var active: bool = false


func get_players():
	return get_parent().online_players

func get_player():
	var players = get_players()
	for player in get_players():
		if players[player]["player_id"] == index:
			return players[player]

func _input(event):
	if get_parent().online_on:
		var player = get_player()
		if active and multiplayer.get_unique_id() == player["peer_id"]:
			if event.is_action_pressed("ui_right") and not player["is_ready"]:
				player["skin_index"] += 1
				if player["skin_index"] >= len(global.skins):
					player["skin_index"] = 0
				SelectSound.play()
			if event.is_action_pressed("ui_left") and not player["is_ready"]:
				player["skin_index"] -= 1
				if player["skin_index"] < 0:
					player["skin_index"] = len(global.skins)-1
				SelectSound.play()
			# heeere
			if event.is_action_pressed("ui_accept") and not get_parent().is_skin_taken(player["skin_index"], player["peer_id"]):
				OkSound.play()
				player["is_ready"] = !player["is_ready"]
			
			get_parent().add_player.rpc_id(1, multiplayer.get_unique_id(), player["skin_index"], global.online_name, player['is_ready'])

			if event.is_action_pressed("ui_cancel"):
				get_parent().leave_game(player["peer_id"])

func _process(_delta):
	update()

func update_outline():
	if get_players().size() >= 3:
		outline.show()
		if index in [1,3]:
			outline.color = global.blue_team_color
		else:
			outline.color = global.red_team_color
	else:
		outline.hide()

func update():
	var player = get_player()
	if player:
		update_skin(player["skin_index"])
		set_ready(player["is_ready"])
		update_outline()
		update_name()
		activate(true)
	else:
		activate(false)

func update_skin(skin_index):
	sprite.modulate = global.skins[skin_index]
	if get_parent().is_skin_taken(skin_index, get_player()["peer_id"]):
		cross.show()
	else:
		cross.hide()

func update_name():
	lbl_name.text = get_player()["name"]

func set_ready(boolean):
	if boolean:
		$active/lbl_ready.label_settings.set_font_color(Color("#FFFFFF"))
		$active/left.hide()
		$active/right.hide()
	else:
		$active/lbl_ready.label_settings.set_font_color(Color("#828282"))
		$active/left.show()
		$active/right.show()


func activate(boolean):
	if active != boolean:
		active = boolean
		if active:
			$active.show()
			$inactive.hide()
		else:
			$active.hide()
			$inactive.show()
