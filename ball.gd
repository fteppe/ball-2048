extends RigidBody2D
class_name Ball

signal ball_destroyed_in_merge(ball: Ball)

@export var rank : int = 1
@export var rank_colors : Array[Color]
@onready var timer = $Timer

var ball_scene : PackedScene = load("res://Ball.tscn")

var size : int 
var initial_rotation : float
var initial_collider_radius : float
var max_time_death_zone : float = GameModeBall.get_death_time()
var death_zone_time : float = 0.
var is_dying : bool = false

func get_radius():
	return ($CollisionShape2D.shape as CircleShape2D).radius

func update_size_from_rank():
	size = pow(2, rank - 1)
	$Visuals/VisualAnimRoot/Label.text = str(size)
	var radius_from_rank =  0.3 + rank * 0.3
	var collider_radius =  radius_from_rank * initial_collider_radius
	($CollisionShape2D.shape as CircleShape2D).radius = collider_radius
	($Area2D/CollisionShape2D.shape as CircleShape2D).radius = collider_radius + 5
	$Visuals.scale = Vector2(radius_from_rank, radius_from_rank)
	$Visuals/VisualAnimRoot/Sprite2D.modulate = rank_colors[clamp(rank - 1, 0 , rank_colors.size() - 1)]
	self.set_mass(radius_from_rank * radius_from_rank)

func rank_up(other_ball : Ball):
	var new_ball : Ball = ball_scene.instantiate()
	new_ball.global_position = (self.global_position + other_ball.global_position) * 0.5
	new_ball.linear_velocity = (self.linear_velocity + other_ball.linear_velocity) * 0.5
	new_ball.angular_velocity = (self.angular_velocity + other_ball.angular_velocity) * 0.5
	
	new_ball.rank = rank + 1
	self.get_parent().call_deferred("add_child", new_ball)
	new_ball.on_ball_fused()
	other_ball.ball_destroyed_in_merge.emit(other_ball)
	other_ball.queue_free()
	self.ball_destroyed_in_merge.emit(self)
	self.queue_free()

func on_ball_fused():
	update_size_from_rank()
	GameModeBall.ball_created.emit(self)
	$Visuals/AnimationPlayer.play("fuze_anim")
	$Visuals/VisualAnimRoot/CPUParticles2D.restart()
	
	

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_rotation = $Visuals/VisualAnimRoot/Sprite2D.global_rotation
	initial_collider_radius = 51
	GameModeBall.ball_died.connect(game_over)
	update_size_from_rank()
	pass # Replace with function body.

func die():
	GameModeBall.ball_died.emit(self)

func start_deah():
	if !is_dying:
		is_dying = true
		$Visuals/AnimationPlayer.play("death")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if death_zone_time >= 0:
		death_zone_time += delta
	$Visuals/VisualAnimRoot.position = Vector2(randf(), randf()) * clampf(death_zone_time / max_time_death_zone, 0., 1.) * 20.
	$Visuals/VisualAnimRoot/Sprite2D.global_rotation = initial_rotation
	if death_zone_time > max_time_death_zone:
		start_deah()
	pass


func _on_body_entered(body : Area2D):
	if body.get_parent() is Ball:
		var ball : Ball = body.get_parent()  as Ball
		if ball.rank == self.rank && !ball.is_queued_for_deletion() && !self.is_queued_for_deletion():
			rank_up(ball)
	pass # Replace with function body.
	
func is_in_alive_zone():
	death_zone_time = -1.

func exited_alive_zone(max_time : float):
	death_zone_time = 0.
	max_time_death_zone = max_time
	
func game_over(ball : Ball):
	timer.start(randf_range(0.1, 1.))
	timer.timeout.connect(start_deah)
