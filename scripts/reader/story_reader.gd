extends Node

class_name StoryReader

static func read_CSV(file_path: String):
	StoryRunner.clear_payloads()
	var file = FileAccess.open(file_path, FileAccess.READ)
	while !file.eof_reached():
		var line = file.get_line()
		if line != "":
			var splited = line.split("_", false, -1)
			var id_str: String = splited[0]
			var id: int = id_str.to_int()
			var command: String = splited[1]
			var arguments: Array = splited.slice(2)
			StoryRunner.add_payload(StoryPayload.new(id, command, arguments))

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
