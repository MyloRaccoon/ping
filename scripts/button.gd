extends Node2D

@export var label : String
@export var checkbox : bool
var hovered : bool = false
var selected : bool = false
var img
var img_hover
var img_select
var img_hover_select

# Called when the node enters the scene tree for the first time.
func _ready():
	img = load("res://assets/UI/"+ label +".png")
	img_hover = load("res://assets/UI/"+ label +"Hover.png")
	if checkbox:
		img_select = load("res://assets/UI/"+ label +"Select.png")
		img_hover_select = load("res://assets/UI/"+ label +"HoverSelect.png")

func _process(_delta):
	var sufix_img : String = ""
	if hovered:
		sufix_img += "Hover"
	if selected and checkbox:
		sufix_img += "Select"
	sufix_img += ".png"
	$sprite.texture = load("res://assets/UI/"+ label + sufix_img)
