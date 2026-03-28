extends Node2D
class_name BallSpawner

var ball_scene = load("res://Ball.tscn")
var is_held : bool = false
var last_dropped_ball : Ball
# Called when the node enters the scene tree for the first time.
func _ready():
	generate_ball()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate_ball():
	if last_dropped_ball:
		last_dropped_ball.body_entered.disconnect(ball_collided)
	last_dropped_ball = ball_scene.instantiate()
	self.add_child(last_dropped_ball)
	last_dropped_ball.process_mode = Node.PROCESS_MODE_DISABLED

func ball_collided(body):
	generate_ball()
	
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed && event.button_index == 1:
			is_held = true
		if event.is_released() && event.button_index == 1 && is_held:
			is_held = false
			last_dropped_ball.body_entered.connect(ball_collided)
			last_dropped_ball.process_mode = Node.PROCESS_MODE_INHERIT
			self.remove_child(last_dropped_ball)
			last_dropped_ball.global_position = $SpawnPoint.global_position
			self.get_parent().add_child(last_dropped_ball)

func get_is_held():
	return is_held
