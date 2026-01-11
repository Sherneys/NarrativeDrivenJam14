extends Object

class_name StoryPayload

var id: int
var command: String
var arguments: Array

func _init(p_id: int, p_command: String, p_arguments: Array):
	id = p_id
	command = p_command
	arguments = p_arguments
