extends Node2D

			
var ball_scene = load("res://Ball.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed && event.button_index == 1:
			var ball : Ball = ball_scene.instantiate()
			ball.global_position = $SpawnPoint.global_position
			self.get_parent().add_child(ball)
