extends Control

@export var default : int
@export var orientation : String
var indexP_btn
var indexM_btn
var index
@onready var N_menu = get_children().size()
var active : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	index = default
	if N_menu > 0:
		if orientation == "v":
			indexP_btn = "ui_down"
			indexM_btn = "ui_up"
			for menu in get_children():
				menu.set_orientation("h")
		elif orientation == "h":
			indexP_btn = "ui_right"
			indexM_btn = "ui_left"
			for menu in get_children():
				menu.set_orientation("v")
		on_select()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if active and N_menu > 0:
		if Input.is_action_just_pressed(indexM_btn):
			index -= 1
			on_select()
		elif Input.is_action_just_pressed(indexP_btn):
			index += 1
			on_select()

func on_select():
	if index >= N_menu:
		index = 0
	elif index < 0:
		index = N_menu - 1
	select(get_children()[index])

func select(m):
	for menu in get_children():
		menu.activate(false)
	m.activate(true)
