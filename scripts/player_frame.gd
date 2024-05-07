extends Node2D

@export var index : int

var is_ready = false
var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$name.text = "Player " + str(index)
	$Sprite2D.modulate = global.skins[global.player_skin[int(index)-1]]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if active:
		if Input.is_action_just_pressed("right" + str(index)) and not is_ready:
			global.player_skin[int(index)-1] += 1
			if global.player_skin[int(index)-1] > len(global.skins)-1:
				global.player_skin[int(index)-1] = 0
			update_skin()
		if Input.is_action_just_pressed("left" + str(index)) and not is_ready:
			global.player_skin[int(index)-1] -= 1
			if global.player_skin[int(index)-1] < 0:
				global.player_skin[int(index)-1] = len(global.skins) -1
			update_skin()
		if Input.is_action_just_pressed("focus" + str(index)) and not global.color_taken(global.player_skin[index-1], index-1):
			switch_ready()

func update_skin():
	$Sprite2D.modulate = global.skins[global.player_skin[int(index)-1]]

func switch_ready():
	is_ready = !is_ready
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
		switch_ready()
