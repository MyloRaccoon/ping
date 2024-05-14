extends Control

@export var default : int
@export var orientation : String
var indexP_btn
var indexM_btn
var index
@onready var menus = get_menus()
@onready var N_menu = menus.size()
var active : bool = true

func get_menus():
	var menus_list = []
	for menu in get_children():
		if menu in get_tree().get_nodes_in_group("menu"):
			menus_list.append(menu)
	return menus_list

# Called when the node enters the scene tree for the first time.
func _ready():
	index = default
	if N_menu > 0:
		if orientation == "v":
			indexP_btn = "ui_down"
			indexM_btn = "ui_up"
			for menu in menus:
				menu.set_orientation("h")
		elif orientation == "h":
			indexP_btn = "ui_right"
			indexM_btn = "ui_left"
			for menu in menus:
				menu.set_orientation("v")
		on_select()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if active and N_menu > 0:
		if event.is_action_pressed(indexM_btn):
			index -= 1
			SelectSound.play()
			on_select()
		elif event.is_action_pressed(indexP_btn):
			index += 1
			SelectSound.play()
			on_select()

func on_select():
	if index >= N_menu:
		index = 0
	elif index < 0:
		index = N_menu - 1
	select(menus[index])

func select(m):
	for menu in menus:
		menu.activate(false)
	m.activate(true)
