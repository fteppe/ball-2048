extends Node

signal ball_created(ball : Ball)
signal ball_died(ball: Ball)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_death_time() -> float:
	return 5.
