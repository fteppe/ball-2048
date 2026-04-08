extends Control

static var settings_menu : PackedScene = load("res://UI/SettingsMenu.tscn")
static var game_over_menu : PackedScene = load("res://UI/GameOverMenu.tscn")

var level : int = 0
var size_ball : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	GameModeBall.level_up.connect(_on_level_up)
	GameModeBall.game_over.connect(_game_over)

func _game_over(level_in : int, size_in : int):
	level = level_in
	size_ball = size_in
	if %TimerGameOverMenu.is_stopped():
		%TimerGameOverMenu.start()

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
	$HBoxContainer/CurrentLevel/CPUParticles2D.restart()


func _on_settings_pressed():
	var settings_name = "SettingsMenu"
	var found_child = %PopupContainer.find_child(settings_name, false, false)
	if found_child == null:
		var settings_menu_node = settings_menu.instantiate()
		settings_menu_node.name = settings_name
		%PopupContainer.add_child(settings_menu_node)
	else:
		found_child.queue_free()

func _on_timer_game_over_menu_timeout():
	var game_over_name = "GameOverMenu"
	if %PopupContainer.find_child(game_over_name, false, false) == null:
		var game_over_menu : GameOverMenu = game_over_menu.instantiate()
		game_over_menu.set_size_level( level, size_ball)
		%PopupContainer.add_child(game_over_menu)
		game_over_menu.name =game_over_name
