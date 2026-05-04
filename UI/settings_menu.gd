extends PanelContainer

var delete_save_popup_menu : String = "res://UI/DeleteSavePopup.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var max_rank = str(GameModeBall.get_max_ball_size())
	if max_rank != %MaxRank.text:
		%MaxRank.text = str(GameModeBall.get_max_ball_size())
	var max_level = str(GameModeBall.get_max_level())
	if max_level != %MaxLevel.text:
		%MaxLevel.text = str(GameModeBall.get_max_level())
	pass


func _on_return_pressed():
	self.queue_free()


func _on_restart_pressed():
	GameModeBall.reset_game_mode()


func _on_clear_save_pressed():
	var delete_save_scene : PackedScene = load(delete_save_popup_menu)
	var name_menu = delete_save_scene.resource_name
	if !%PopupContainer.find_child(name_menu):
		var menu = delete_save_scene.instantiate()
		menu.name = name_menu
		%PopupContainer.add_child(menu)
