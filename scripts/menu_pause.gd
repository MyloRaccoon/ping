extends Control

signal pressed(btn)

@export var N_button : int = 2
var index = 0
var active : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	on_select()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		if Input.is_action_just_pressed('ui_up'):
			index -= 1
			on_select()
		elif Input.is_action_just_pressed("ui_down"):
			index += 1
			on_select()
		

func on_select():
	if index >= N_button:
		index = 0
	elif index < 0:
		index = N_button - 1
	match index:
		0: select($btn_resume)
		1: select($btn_quit)

func select(btn):
	$btn_resume.hovered = false
	$btn_quit.hovered = false
	btn.hovered = true


func _on_btn_play_pressed():
	emit_signal("pressed", "play")


func _on_btn_quit_pressed():
	emit_signal("pressed", "quit")

func activate(boolean):
	active = boolean
	$btn_resume.active = boolean
	$btn_quit.active = boolean
