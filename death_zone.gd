extends Node2D

@export var max_death_zone_time : float

var balls_in_area : Dictionary[Ball, float]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for ball in balls_in_area:
		if ball.is_queued_for_deletion():
			balls_in_area.erase(ball as Ball)
		else:
			balls_in_area[ball] += delta
			ball.set_death_zone_ratio(clampf(balls_in_area[ball] / max_death_zone_time, 0., 1))
			
	pass


func _on_area_2d_body_entered(body):
	if body is Ball:
		balls_in_area[body as Ball] = 0.
	pass # Replace with function body.


func _on_area_2d_body_exited(body):
	if body is Ball:
		body.set_death_zone_ratio(0)
		balls_in_area.erase(body as Ball)
	pass # Replace with function body.
