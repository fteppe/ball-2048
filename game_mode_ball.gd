extends Node

signal ball_created(ball : Ball)
signal ball_died(ball: Ball)
signal level_up(new_level : int)

@export var level_scores : Array[int]

var current_score : int = 0
var current_level : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_level():
	return current_level

func get_score():
	return current_score

func get_score_to_reach():
	return level_scores[min(level_scores.size() - 1, current_level)]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_death_time() -> float:
	return 5.

func reset_game_mode():
	current_score = 0
	current_level = 0
	print("game mode reset")
	#do nothing for now

func _level_up():
	current_score = max(0 , current_score - get_score_to_reach())
	current_level += 1
	level_up.emit(current_level)

func _on_ball_created(ball : Ball):
	current_score += pow(2, ball.rank)
	while current_score > get_score_to_reach():
		_level_up()
	pass # Replace with function body.
