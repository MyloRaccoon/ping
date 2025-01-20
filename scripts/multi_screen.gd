extends Node2D

@onready var transition = $transition

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_menu_pressed(btn: Variant) -> void:
	match btn:
		'back': transition.exit("back")


func _on_transition_exited(msg: Variant) -> void:
	match msg:
		'back': get_tree().change_scene_to_file("res://scenes/option.tscn")
