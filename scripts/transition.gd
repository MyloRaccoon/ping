extends CanvasLayer

signal entered
signal exited(msg)

var entering = false
var exiting = false

var exit_msg = ""

func _ready():
	enter()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if entering:
		$enter.position += Vector2(-64, 0)
	if exiting:
		$exit.position += Vector2(-64, 0)

func enter():
	entering = true
	
func exit(msg = ""):
	exiting = true
	exit_msg = msg

func _on_enter_visible_on_screen_notifier_2d_screen_exited():
	entering = false
	emit_signal("entered")

func _on_exit_visible_on_screen_notifier_2d_screen_entered():
	exiting = false
	emit_signal("exited", exit_msg)
