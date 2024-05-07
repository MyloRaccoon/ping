extends CharacterBody2D

@export var index : String
@export var push_force : float
@export var base_speed : int
var speed

func _ready():
	$Sprite2D.modulate = global.skins[global.player_skin[int(index)-1]]

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
				var impulse = -c.get_normal() * push_force
				c.get_collider().apply_central_impulse(impulse)

