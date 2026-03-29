extends Node2D
class_name BallSpawner

var ball_scene = load("res://Ball.tscn")
var is_held : bool = false
var last_dropped_ball : Ball
var held_ball : Ball
var max_rank_reached : int = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	generate_ball()
	GameModeBall.ball_created.connect(ball_created)
	pass # Replace with function body.

func ball_created(ball : Ball):
	max_rank_reached = max(max_rank_reached, ball.rank)

func get_rank_to_generate():
	var max_rank_to_generate = max(max_rank_reached/2, 3)
	var rank_to_generate = clampf(randfn(max_rank_to_generate / 2, 1), 1, max_rank_to_generate)
	return rank_to_generate

func generate_ball():
	if last_dropped_ball:
		last_dropped_ball.body_entered.disconnect(ball_collided)
	last_dropped_ball = null
	held_ball = ball_scene.instantiate()
	held_ball.rank = get_rank_to_generate()
	self.call_deferred("add_child", held_ball)
	held_ball.process_mode = Node.PROCESS_MODE_DISABLED

func ball_collided(_body):
	generate_ball()
	
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed && event.button_index == 1:
			is_held = true
		if event.is_released() && event.button_index == 1 && is_held && held_ball:
			is_held = false
			held_ball.body_entered.connect(ball_collided)
			held_ball.process_mode = Node.PROCESS_MODE_INHERIT
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
