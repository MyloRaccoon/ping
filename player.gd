extends CharacterBody2D

@export var index : String
@export var push_force : float
@export var base_speed : int
var speed

func _ready():
	match index:
		"1": $Sprite2D.set_texture(preload("res://p1.png"))
		"2": $Sprite2D.set_texture(preload("res://p2.png"))

func _physics_process(_delta):
	if global.playing:
		if Input.is_action_pressed('focus'+index):
			speed = int(base_speed/3.0)
		else:
			speed = base_speed
		
		var direction = Input.get_vector("left"+index, "right"+index, "up"+index, "down"+index)
		velocity = direction * speed
		move_and_slide()
		for i in get_slide_collision_count():
			var c = get_slide_collision(i)
			if c.get_collider() is RigidBody2D:
				c.get_collider().apply_central_impulse(-c.get_normal() * push_force)

