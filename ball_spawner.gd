extends Node2D
class_name BallSpawner

var ball_scene = load("res://Ball.tscn")
var is_held : bool = false
var last_dropped_ball : Ball
var held_ball : Ball

var max_rank_reached : int = 1
var last_generated_rank : int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_ball()
	GameModeBall.ball_died.connect(_game_over)
	GameModeBall.ball_created.connect(ball_created)
	pass # Replace with function body.

func _game_over(ball : Ball):
	held_ball.queue_free()
	held_ball = null

func ball_created(ball : Ball):
	max_rank_reached = max(max_rank_reached, ball.rank)

func get_rank_to_generate():
	var max_rank_starter = 3
	var max_rank_to_generate = max(max_rank_reached/2, max_rank_starter)
	var max_rank_to_loop = max(max_rank_to_generate / 2, max_rank_starter)
	var next_rank_to_gen_center = last_generated_rank + 1
	if next_rank_to_gen_center > max_rank_to_loop: #we loop around
		next_rank_to_gen_center = 1
	print("rank center is ", next_rank_to_gen_center, " max rank is ", max_rank_to_generate)
	#we chose the rank centered around the next epxected one, with some chance to pick something else
	var random_normal_result = randfn(next_rank_to_gen_center, 2)
	print("random_normal_result ",random_normal_result)
	var rank_to_generate = clampf(random_normal_result, 1, max_rank_to_generate)
	last_generated_rank = rank_to_generate
	return rank_to_generate

func generate_ball():
	if last_dropped_ball:
		last_dropped_ball.body_entered.disconnect(ball_collided)
		last_dropped_ball.ball_destroyed_in_merge.disconnect(ball_collided)
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
			held_ball.ball_destroyed_in_merge.connect(ball_collided)
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
