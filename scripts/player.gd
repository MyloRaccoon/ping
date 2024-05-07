extends CharacterBody2D

@export var index : String
@export var push_force : float
@export var base_speed : int
var speed

func _ready():
	if global.players[int(index)-1]:
		show()
		$CollisionPolygon2D.disabled = false
		$Sprite2D.modulate = global.skins[global.player_skin[int(index)-1]]
		if global.get_n_player_ready() > 2:
			if index in ["1", "3"]:
				$PointLight2D.color = global.blue_team_color
			else:
				$PointLight2D.color = global.red_team_color
	else:
		hide()
		$CollisionPolygon2D.disabled = true

func _physics_process(_delta):
	if global.playing and global.players[int(index)-1]:
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

