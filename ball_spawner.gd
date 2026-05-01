extends Node2D
class_name BallSpawner

var ball_scene = load("res://Ball.tscn")
var is_held : bool = false
var last_dropped_ball : Ball
var held_ball : Ball

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_ball()
	GameModeBall.ball_died.connect(_game_over)
	pass # Replace with function body.

func _game_over(ball : Ball):
	if held_ball:
		held_ball.queue_free()
		held_ball = null

func generate_ball():
	if held_ball:
		return
	if last_dropped_ball:
		last_dropped_ball.body_entered.disconnect(ball_collided)
		last_dropped_ball.ball_destroyed_in_merge.disconnect(ball_collided)
	last_dropped_ball = null
	held_ball = ball_scene.instantiate()
	held_ball.rank = GameModeBall.pop_next_ball_rank()
	self.call_deferred("add_child", held_ball)
	held_ball.process_mode = Node.PROCESS_MODE_DISABLED

func ball_collided(_body):
	generate_ball()
	
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed && event.button_index == 1:
			is_held = true
		if event.is_released() && event.button_index == 1 && is_held:
			is_held = false
			if held_ball:
				held_ball.body_entered.connect(ball_collided)
				held_ball.ball_destroyed_in_merge.connect(ball_collided)
				held_ball.drop_ball()
				last_dropped_ball = held_ball
				self.remove_child(held_ball)
				held_ball = null
				last_dropped_ball.global_position = $SpawnPoint.global_position
				self.get_parent().add_child(last_dropped_ball)

func get_held_ball_radius() :
	if held_ball:
		return held_ball.get_radius()
	return 0.

func get_is_held():
	return is_held
