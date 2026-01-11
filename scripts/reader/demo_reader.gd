extends Node

var story_path: String = "res://assets/story/demo_story.txt"

# Called when the node enters the scene tree for the first time.
func _ready():
	StoryReader.read_CSV(story_path)
	StoryRunner.start_run()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
