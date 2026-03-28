extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var previous_mouse_pos_x : float

func _unhandled_input(event):
	var current_mouse_pos = $BallSpawner.get_global_mouse_position().x
	if event is InputEventMouseMotion && $BallSpawner.get_is_held():
		$BallSpawner.global_position.x = clampf($BallSpawner.global_position.x + current_mouse_pos - previous_mouse_pos_x, $Left.global_position.x,  $Right.global_position.x)
	
	previous_mouse_pos_x = current_mouse_pos
