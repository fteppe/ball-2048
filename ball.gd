extends RigidBody2D
class_name Ball

@export var rank : int = 1
@export var rank_colors : Array[Color]

var size : int 
var initial_rotation : float

func get_radius():
	return ($CollisionShape2D.shape as CircleShape2D).radius

func update_size_from_rank():
	size = pow(2, rank - 1)
	$Visuals/Label.text = str(size)
	var radius_from_rank = sqrt(rank) * 2
	($CollisionShape2D.shape as CircleShape2D).radius = radius_from_rank * 10
	$Visuals.scale = Vector2(radius_from_rank, radius_from_rank)
	$Visuals/Sprite2D.modulate = rank_colors[clamp(rank - 1, 0 , rank_colors.size())]
	self.set_mass(radius_from_rank * radius_from_rank)

func rank_up():
	rank += 1
	update_size_from_rank()


# Called when the node enters the scene tree for the first time.
func _ready():
	initial_rotation = $Visuals/Sprite2D.global_rotation
	update_size_from_rank()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Visuals/Sprite2D.global_rotation = initial_rotation
	pass


func _on_body_entered(body : Variant):
	if body is Ball:
		var ball : Ball = body as Ball
		if ball.rank == self.rank:
			rank_up()
			ball.queue_free()
	pass # Replace with function body.
