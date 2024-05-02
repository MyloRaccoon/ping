extends Control

signal pressed(btn)

@onready var N_button = get_children().size()
var index = 0
var active : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	if N_button > 0:
		on_select()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active and N_button > 0:
		if Input.is_action_just_pressed('ui_up'):
			index -= 1
			on_select()
		elif Input.is_action_just_pressed("ui_down"):
			index += 1
			on_select()
		if Input.is_action_just_pressed("ui_accept"):
			emit_signal("pressed", get_children()[index].label)

func on_select():
	if index >= N_button:
		index = 0
	elif index < 0:
		index = N_button - 1
	select(get_children()[index])

func select(btn):
	for button in get_children():
		button.hovered = false
	btn.hovered = true

func activate(boolean):
	active = boolean
	for btn in get_children():
		btn.active = boolean
