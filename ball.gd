extends RigidBody2D
class_name Ball

@export var rank : int = 1
@export var rank_colors : Array[Color]

var ball_scene : PackedScene = load("res://Ball.tscn")

var size : int 
var initial_rotation : float
var initial_collider_radius : float

func disable_collider():
	$CollisionShape2D.process_mode = Node.PROCESS_MODE_DISABLED

func is_collider_disabled() -> bool:
	return $CollisionShape2D.process_mode == Node.PROCESS_MODE_DISABLED

func get_radius():
	return ($CollisionShape2D.shape as CircleShape2D).radius

func update_size_from_rank():
	size = pow(2, rank - 1)
	$Visuals/Label.text = str(size)
	var radius_from_rank = sqrt(rank) * 0.4
	($CollisionShape2D.shape as CircleShape2D).radius = radius_from_rank * initial_collider_radius
	$Visuals.scale = Vector2(radius_from_rank, radius_from_rank)
	$Visuals/Sprite2D.modulate = rank_colors[clamp(rank - 1, 0 , rank_colors.size() - 1)]
	self.set_mass(radius_from_rank * radius_from_rank)

func rank_up(other_ball : Ball):
	var new_ball : Ball = ball_scene.instantiate()
	new_ball.global_position = (self.global_position + other_ball.global_position) * 0.5
	new_ball.linear_velocity = (self.linear_velocity + other_ball.linear_velocity) * 0.5
	new_ball.angular_velocity = (self.angular_velocity + other_ball.angular_velocity) * 0.5
	
	new_ball.rank = rank + 1
	GameModeBall.ball_created.emit(new_ball)
	new_ball.update_size_from_rank()
	self.get_parent().call_deferred("add_child", new_ball)
	self.disable_collider()
	other_ball.disable_collider()
	other_ball.queue_free()
	self.queue_free()


# Called when the node enters the scene tree for the first time.
func _ready():
	initial_rotation = $Visuals/Sprite2D.global_rotation
	initial_collider_radius = 50
	update_size_from_rank()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Visuals/Sprite2D.global_rotation = initial_rotation
	pass



func _on_body_entered(body : Variant):
	if body is Ball:
		var ball : Ball = body as Ball
		if ball.rank == self.rank && !ball.is_collider_disabled() && !self.is_collider_disabled():
			rank_up(ball)
	pass # Replace with function body.
