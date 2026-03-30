extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


#in the end it is more of an alive sone than a death zone
func body_is_out_of_alive_zone(body : Node2D):
	if body is Ball && !body.is_queued_for_deletion():
		body.exited_alive_zone(GameModeBall.get_death_time())
	pass # Replace with function body.


func body_is_in_alive_zone(body):
	if body is Ball:
		body.is_in_alive_zone()
	pass # Replace with function body.
