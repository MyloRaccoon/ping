extends Node2D

@export var index : int

var is_ready = false
var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$active/name.text = "Player " + str(index)
	$inactive/name.text = "Player " + str(index)
	$active/Sprite2D.modulate = global.skins[global.player_skin[int(index)-1]]
	match index:
		1: $inactive/key.text = "E"
		2: $inactive/key.text = "1"
		3: $inactive/key.text = "U"
		4: $inactive/key.text = "$"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if active:
		update_skin()
		if event.is_action_pressed("right" + str(index)) and not is_ready:
			global.player_skin[int(index)-1] += 1
			if global.player_skin[int(index)-1] > len(global.skins)-1:
				global.player_skin[int(index)-1] = 0
			SelectSound.play()
		if event.is_action_pressed("left" + str(index)) and not is_ready:
			global.player_skin[int(index)-1] -= 1
			if global.player_skin[int(index)-1] < 0:
				global.player_skin[int(index)-1] = len(global.skins) -1
			SelectSound.play()
		if event.is_action_pressed("focus" + str(index)) and not global.color_taken(global.player_skin[index-1], index-1):
			OkSound.play()
			set_ready(!is_ready)

func _process(_delta):
	if global.n_frame_active > 2:
		$active/outline.show()
		if index in [1,3]:
			$active/outline.color = global.blue_team_color
		else:
			$active/outline.color = global.red_team_color
	else:
		$active/outline.hide()

func update_skin():
	$active/Sprite2D.modulate = global.skins[global.player_skin[int(index)-1]]
	if global.color_taken(global.player_skin[index-1], index-1):
		$active/cross.show()
	else:
		$active/cross.hide()

func set_ready(boolean):
	is_ready = boolean
	global.players[index-1] = is_ready
	if is_ready:
		$active/lbl_ready.label_settings.set_font_color(Color("#FFFFFF"))
		$active/left.hide()
		$active/right.hide()
	else:
		$active/lbl_ready.label_settings.set_font_color(Color("#828282"))
		$active/left.show()
		$active/right.show()

func activate():
	active = !active
	if active:
		$active.show()
		$inactive.hide()
	else:
		$active.hide()
		$inactive.show()
		if is_ready:
			set_ready(false)
