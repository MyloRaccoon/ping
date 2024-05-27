extends RigidBody2D

var on_screen = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	print("linear_velocity : " + str(linear_velocity))
	print("position : " + str(position))


func _on_visible_on_screen_notifier_2d_screen_entered():
	print("entered")
	on_screen = true


func _on_visible_on_screen_notifier_2d_screen_exited():
	print("exited")
	on_screen = false
