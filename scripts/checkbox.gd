extends Button_base
class_name Checkbox

@onready var select_rect: ColorRect = $select

@export var selected: bool

func _ready() -> void:
	select(selected)
	super()

func select(boolean: bool):
	selected = boolean
	if selected:
		select_rect.color = Color8(255, 0, 0)
	else:
		select_rect.color = Color8(0, 0, 0)
