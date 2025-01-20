extends Control

signal pressed(btn)

@export var checkbox: bool
@export var orientation : String
@export var default: int
var indexP_btn
var indexM_btn

@onready var buttons = get_buttons()
@onready var N_button = buttons.size()
@onready var index = default
var active : bool = true

func get_buttons():
	var buttons_list = []
	for btn in get_children():
		if btn in get_tree().get_nodes_in_group("btn"):
			buttons_list.append(btn)
	return buttons_list

# Called when the node enters the scene tree for the first time.
func _ready():
	if N_button > 0:
		#for button in buttons:
			#button.checkbox = checkbox
		set_orientation(orientation)
		on_hover()
		if checkbox:
			select(buttons[index])

func set_orientation(o):
	orientation = o
	if orientation == "v":
			indexP_btn = "ui_down"
			indexM_btn = "ui_up"
	else:
		indexP_btn = "ui_right"
		indexM_btn = "ui_left"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if active and N_button > 0:
		if Input.is_action_just_pressed(indexM_btn):
			index -= 1
			SelectSound.play()
			on_hover()
		elif Input.is_action_just_pressed(indexP_btn):
			index += 1
			SelectSound.play()
			on_hover()
		if Input.is_action_just_pressed("ui_accept"):
			OkSound.play()
			var btn = buttons[index]
			if is_instance_of(btn, Checkbox):
				select(btn)
			pressed.emit(btn.message)

func on_hover():
	if index >= N_button:
		index = 0
	elif index < 0:
		index = N_button - 1
	hover(buttons[index])

func hover(btn):
	for button in buttons:
		button.hover(false)
	btn.hover(true)

func select(btn: Checkbox):
	for button: Checkbox in buttons:
		button.select(false)
	btn.select(true)

func activate(boolean):
	active = boolean
	if boolean:
		on_hover()
	else:
		for button in buttons:
			button.hover(false)

func add_button(btn):
	add_child(btn)
	buttons.append(btn)
	N_button = buttons.size()

func remove_last_button():
	buttons.pop().queue_free()
	N_button = buttons.size()
	index = 0
	on_hover()
