extends Node2D

@export var index : int

var is_ready = false
var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$name.text = "Player " + str(index)
	$Sprite2D.modulate = global.skins[global.player_skin[int(index)-1]]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if active:
		if event.is_action_pressed("right" + str(index)) and not is_ready:
			global.player_skin[int(index)-1] += 1
			if global.player_skin[int(index)-1] > len(global.skins)-1:
				global.player_skin[int(index)-1] = 0
			update_skin()
		if event.is_action_pressed("left" + str(index)) and not is_ready:
			global.player_skin[int(index)-1] -= 1
			if global.player_skin[int(index)-1] < 0:
				global.player_skin[int(index)-1] = len(global.skins) -1
			update_skin()
		if event.is_action_pressed("focus" + str(index)) and not global.color_taken(global.player_skin[index-1], index-1):
			set_ready(!is_ready)

func _process(_delta):
	if global.n_frame_active > 2:
		$outline.show()
		if index in [1,3]:
			$outline.color = global.blue_team_color
		else:
			$outline.color = global.red_team_color
	else:
		$outline.hide()

func update_skin():
	$Sprite2D.modulate = global.skins[global.player_skin[int(index)-1]]

func set_ready(boolean):
	is_ready = boolean
	global.players[index-1] = is_ready
	if is_ready:
		$lbl_ready.label_settings.set_font_color(Color("#FFFFFF"))
		$left.hide()
		$right.hide()
	else:
		$lbl_ready.label_settings.set_font_color(Color("#828282"))
		$left.show()
		$right.show()

func activate():
	active = !active
	if (not active) and is_ready:
		set_ready(false)
