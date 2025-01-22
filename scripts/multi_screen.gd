extends Node2D

@onready var transition = $transition

@onready var le_ip_address = $address_def/le_ip_address
@onready var le_port = $address_def/le_port
@onready var le_name = $le_name

func _ready() -> void:
	$menu.activate(true)

func focused():
	return le_ip_address.has_focus() or le_port.has_focus() or le_name.has_focus()

func _on_menu_pressed(btn: Variant) -> void:
	if not focused():
		match btn:
			'back': transition.exit("back")
			'join': transition.exit("join")
			'host': transition.exit("host")

func _on_transition_exited(msg: Variant) -> void:
	match msg:
		'back': get_tree().change_scene_to_file("res://scenes/option.tscn")
		'host':
			global.is_host = true
			global.online_name = le_name.text
			get_tree().change_scene_to_file("res://scenes/multi_players_screen.tscn")
		'join':
			global.is_host = false
			global.online_name = le_name.text
			#global.online_ip_address = le_ip_address.text
			#global.online_port = int(le_port.text)
			get_tree().change_scene_to_file("res://scenes/multi_players_screen.tscn")
