extends Control

signal pressed(btn)

@export var checkbox : bool
@export var orientation : String
@export var default: int
var indexP_btn
var indexM_btn

@onready var N_button = get_children().size()
@onready var index = default
var active : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	if N_button > 0:
		for button in get_children():
			button.checkbox = checkbox
		set_orientation(orientation)
		on_hover()
		if checkbox:
			select(get_children()[index])

func set_orientation(o):
	orientation = o
	if orientation == "v":
			indexP_btn = "ui_down"
			indexM_btn = "ui_up"
	else:
		indexP_btn = "ui_right"
		indexM_btn = "ui_left"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if active and N_button > 0:
		if event.is_action_pressed(indexM_btn):
			index -= 1
			on_hover()
		elif event.is_action_pressed(indexP_btn):
			index += 1
			on_hover()
		if event.is_action_pressed("ui_accept"):
			var btn = get_children()[index]
			if checkbox:
				select(btn)
			emit_signal("pressed", btn.label)

func on_hover():
	if index >= N_button:
		index = 0
	elif index < 0:
		index = N_button - 1
	hover(get_children()[index])

func hover(btn):
	for button in get_children():
		button.hovered = false
	btn.hovered = true

func select(btn):
	for button in get_children():
		button.selected = false
	btn.selected = true

func activate(boolean):
	active = boolean
	if boolean:
		on_hover()
	else:
		for button in get_children():
			button.hovered = false

func add_button(btn):
	add_child(btn)
	N_button = get_children().size()

func remove_last_button():
	get_children()[-1].queue_free()
	N_button = get_children().size()
	index = 0
	on_hover()
