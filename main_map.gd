extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		$BallSpawner.global_position.x = clampf($BallSpawner.get_global_mouse_position().x, $Left.global_position.x,  $Right.global_position.x) 
