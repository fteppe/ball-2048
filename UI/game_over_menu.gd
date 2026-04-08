extends PanelContainer
class_name GameOverMenu


func set_size_level(size : int, level : int):
	%Size.text = str(size)
	%Level.text = str(level)

func _on_restart_pressed():
	$".".visible = false
	get_tree().change_scene_to_file("res://MainMap.tscn")
