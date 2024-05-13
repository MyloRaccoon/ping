extends CanvasLayer

signal entered
signal exited(msg)

var entering = false
var exiting = false

var exit_msg = ""

var transitioning : bool = false

func _ready():
	enter()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if entering:
		$enter.position += Vector2(-64, 0)
	elif exiting:
		$exit.position += Vector2(-64, 0)

func enter():
	if not transitioning:
		transitioning = true
		show()
		entering = true
	
func exit(msg = ""):
	if not transitioning:
		transitioning = true
		show()
		exiting = true
		exit_msg = msg

func _on_enter_visible_on_screen_notifier_2d_screen_exited():
	transitioning = false
	hide()
	entering = false
	emit_signal("entered")

func _on_exit_visible_on_screen_notifier_2d_screen_entered():
	transitioning = false
	hide()
	exiting = false
	emit_signal("exited", exit_msg)
