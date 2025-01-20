extends Label
class_name Button_base

@export var message: String

@onready var hover_rec = $hover
#@onready var label = $Label
#
#@export var text : String
var hovered : bool = false

func _ready() -> void:
	#label.text = text
	hover(hovered)
	
func hover(boolean: bool):
	hovered = boolean
	hover_rec.visible = boolean
