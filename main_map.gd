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
		var held_ball_radius = $BallSpawner.get_held_ball_radius()
		$BallSpawner.global_position.x = clampf($BallSpawner.global_position.x + current_mouse_pos - previous_mouse_pos_x, $LeftSpawner.global_position.x + held_ball_radius,  $RightSpawner.global_position.x - held_ball_radius)
	
	previous_mouse_pos_x = current_mouse_pos
