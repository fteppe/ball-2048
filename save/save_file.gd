extends Resource
class_name BallSaveFile

static var save_file = "user://save_file.res"

@export var max_level_reached : int = 0
@export var max_rank_reached : int = 0

func save_to_file():
	print("saved to file "+ str(ResourceSaver.save(self, save_file)))

static func load_from_file() -> BallSaveFile:
	var save_file = ResourceLoader.load(save_file) as BallSaveFile
	if !save_file :
		return BallSaveFile.new()
	else:
		return save_file
