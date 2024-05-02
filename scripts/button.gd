extends Node2D

signal pressed(name)

@export var label : String
var hovered : bool = false
var btn_img 
var btn_hover 
var active : bool = true
# Called when the node enters the scene tree for the first time.
func _ready():
	btn_img = load("res://assets/UI/"+ label +".png")
	btn_hover = load("res://assets/UI/"+ label +"Hover.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:	
		if hovered:
			$sprite.texture = btn_hover
		else:
			$sprite.texture = btn_img
