extends Node
class_name SaveSys

static var instance: SaveSys
const save_path = "user://game_save.txt"

# Called when the node enters the scene tree for the first time.
func _ready():
	instance = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

static func get_instance() -> SaveSys:
	return instance

func save_register():
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	for r in RegisterPool.get_keys():
		var save_string: String
		save_string = str(r) + "_" + str(RegisterPool.get_register(r))
		print("save: " + save_string)
		save_file.store_line(save_string)
	save_file.close()

func load_register():
	var save_file = FileAccess.open(save_path, FileAccess.READ)
	while !save_file.eof_reached():
		var line = save_file.get_line()
		if line != "":
			var splited = line.split("_", false, -1)
			RegisterPool.set_register(int(splited[0]), int(splited[1]))
	save_file.close()
