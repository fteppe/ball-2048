extends Node

signal ball_created(ball : Ball)
signal ball_died(ball: Ball)
signal level_up(new_level : int)
signal game_over(level : int, max_size : int)

@export var level_scores : Array[int]
@export var death_time : float = 5.
var save_file : BallSaveFile
@export var available_shakes : int = 1

var current_score : int = 0
var current_level : int = 0
var current_biggest_ball : int = 0
var game_is_over : bool = false
var game_over_signal_emitted = false

var next_ball_rank : int = 1;
var max_rank_reached : int = 1

func get_next_ball_rank():
	return next_ball_rank

func pop_next_ball_rank() -> int:
	var last_generated_rank = next_ball_rank
	var max_rank_starter = 3
	var max_rank_to_generate = max(max_rank_reached/2, max_rank_starter)
	var max_rank_to_loop = max(max_rank_to_generate / 2, max_rank_starter)
	var next_rank_to_gen_center = last_generated_rank + 1
	if next_rank_to_gen_center > max_rank_to_loop: #we loop around
		next_rank_to_gen_center = 1
	print("rank center is ", next_rank_to_gen_center, " max rank is ", max_rank_to_generate)
	#we chose the rank centered around the next epxected one, with some chance to pick something else
	var random_normal_result = roundi(randfn(next_rank_to_gen_center, 2))
	print("random_normal_result ",random_normal_result)
	var rounded_in_range_value = posmod(random_normal_result - 1, max_rank_to_generate) + 1
	print("modulo of ", (random_normal_result - 1)," and ",max_rank_to_generate," is ", posmod(random_normal_result - 1,max_rank_to_generate))
	var rank_to_generate = rounded_in_range_value
	print("rank_to_generate ",rank_to_generate)
	next_ball_rank = rank_to_generate
	return last_generated_rank

# Called when the node enters the scene tree for the first time.
func _ready():
	ball_died.connect(_game_over)
	self.pop_next_ball_rank()
	save_file = BallSaveFile.load_from_file()
	pass # Replace with function body.

func _game_over(ball :Ball):
	game_is_over = true
	
func clear_save():
	save_file = BallSaveFile.new()
	save_file.save_to_file()

func get_max_ball_size():
	return save_file.max_rank_reached

func get_max_level():
	return save_file.max_level_reached

func get_level():
	return current_level

func get_score():
	return current_score

func get_score_to_reach():
	return level_scores[min(level_scores.size() - 1, current_level)]
	
func get_game_is_over():
	return game_is_over

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_is_over && get_tree().get_nodes_in_group("balls").size() <= 1 && game_over_signal_emitted == false:
		game_over.emit(current_level, current_biggest_ball)
		game_over_signal_emitted = true
	pass

func get_death_time() -> float:
	return death_time

func reset_game_mode():
	current_score = 0
	current_level = 0
	game_is_over = false
	current_biggest_ball = 0
	game_over_signal_emitted = false
	max_rank_reached = 1
	next_ball_rank = 1
	available_shakes = 1
	get_tree().change_scene_to_file("res://MainMap.tscn")

func _level_up():
	current_score = max(0 , current_score - get_score_to_reach())
	current_level += 1
	if current_level % 10 == 0:
		GameModeBall.available_shakes += 1
	if save_file.max_level_reached < current_level:
		save_file.max_level_reached = current_level
		save_file.save_to_file()
	level_up.emit(current_level)

func _on_ball_created(ball : Ball):
	var ball_size =  pow(2, ball.rank - 1)
	current_score += ball_size
	current_biggest_ball = max(ball_size, current_biggest_ball)
	max_rank_reached = max(max_rank_reached, ball.rank)
	if save_file.max_rank_reached < ball_size:
		save_file.max_rank_reached = ball_size
		save_file.save_to_file()
	while current_score > get_score_to_reach():
		_level_up()
	
