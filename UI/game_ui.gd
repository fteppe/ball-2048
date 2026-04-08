extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	GameModeBall.level_up.connect(_on_level_up)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var current_score = str(GameModeBall.get_score())
	if current_score != %Score.text:
		%Score.text = current_score
	%ScoreProgress.value = GameModeBall.get_score()
	var max_rank = str(GameModeBall.get_max_ball_size())
	if max_rank != %MaxRank.text:
		%MaxRank.text = str(GameModeBall.get_max_ball_size())
	var max_level = str(GameModeBall.get_max_level())
	if max_level != %MaxLevel.text:
		%MaxLevel.text = str(GameModeBall.get_max_level())

func _on_level_up(new_level : int):
	%ScoreProgress.max_value = GameModeBall.get_score_to_reach()
	%CurrentLevel.text = str(GameModeBall.get_level())
	$VBoxContainer/HBoxContainer/CurrentLevel/CPUParticles2D.restart()

func _on_button_button_up():
	get_tree().change_scene_to_file("res://MainMap.tscn")
	pass # Replace with function body.
