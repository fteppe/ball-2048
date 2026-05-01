extends Node2D
class_name MainMap

# Called when the node enters the scene tree for the first time.
func _ready():
	GameModeBall.reset_game_mode()
	GameModeBall.ball_created.connect(ball_created)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var previous_mouse_pos_x : float

func ball_created(ball : Ball):
	print("Ball created rank ", ball.rank)
	$Camera2D/AnimationPlayer.play("screen_shake")

func _unhandled_input(event):
	var current_mouse_pos = %BallSpawner.get_global_mouse_position().x
	if event is InputEventMouseMotion && %BallSpawner.get_is_held():
		var held_ball_radius = %BallSpawner.get_held_ball_radius()
		%BallSpawner.global_position.x = clampf(%BallSpawner.global_position.x + current_mouse_pos - previous_mouse_pos_x, %LeftSpawner.global_position.x + held_ball_radius,  %RightSpawner.global_position.x - held_ball_radius)
	
	previous_mouse_pos_x = current_mouse_pos


func _on_game_ui_shake_screen():
	%AnimationPlayer.play("screen_shake")
	pass # Replace with function body.

func on_start_shake():
	%BallSpawner.locked = true
	%DeathZone.process_mode = Node.PROCESS_MODE_DISABLED

func on_end_shake():
	%BallSpawner.locked = false
	%DeathZone.process_mode = Node.PROCESS_MODE_INHERIT
