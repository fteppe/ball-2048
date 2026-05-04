extends Node2D
class_name MainMap

var shake_intensity : float = 0

static func clear_middle_keys_in_track(animation : Animation, track_idx : int):
	while animation.track_get_key_count(track_idx) > 2:
		animation.track_remove_key(track_idx, 1)

func generate_shake_anim():
	var shake_anim : Animation= (%AnimationPlayer.get_animation("screen_shake") as Animation)
	var animation_track : int = shake_anim.find_track("GameWorld/PlaygroundBalls/ShakeOffsetRoot:position", Animation.TYPE_VALUE)
	var key_time : float = randf_range(0.2,0.3)
	var offset_range = 40.
	var rotation_range = 0.1
	if animation_track >= 0:
		clear_middle_keys_in_track(shake_anim, animation_track)
		print("generating shake")
		while key_time < shake_anim.get_length() - 0.3:
			var offset = Vector2(randf_range(-offset_range, offset_range), randf_range(-offset_range, offset_range))
			shake_anim.track_insert_key(animation_track, key_time, offset)
			key_time += randf_range(0.2,0.3)
	key_time = randf_range(0.2,0.3)
	animation_track = shake_anim.find_track("GameWorld/PlaygroundBalls/ShakeOffsetRoot:rotation", Animation.TYPE_VALUE)
	if animation_track:
		clear_middle_keys_in_track(shake_anim, animation_track)
		while key_time < shake_anim.get_length() - 0.3:
			shake_anim.track_insert_key(animation_track, key_time, randf_range(-rotation_range, rotation_range))
			key_time += randf_range(0.2,0.3)

# Called when the node enters the scene tree for the first time.
func _ready():
	GameModeBall.ball_created.connect(ball_created)
	generate_shake_anim()
	
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
	%DeathZone.disable_death_zone()
	#Animatablebody isn't as stable as static body so we switch between the two when there is or isn't animation
	%StaticWalls.process_mode = Node.PROCESS_MODE_DISABLED
	%DynamicWalls.process_mode = Node.PROCESS_MODE_INHERIT

func on_end_shake():
	%BallSpawner.locked = false
	%DeathZone.enable_death_zone()
	%StaticWalls.process_mode = Node.PROCESS_MODE_INHERIT
	%DynamicWalls.process_mode = Node.PROCESS_MODE_DISABLED
