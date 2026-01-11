extends Control
class_name DialogSys

static var dialog_box: Control
static var dialog_name: RichTextLabel
static var dialog_text: RichTextLabel
static var tree

static var instance: DialogSys

@export var text_visual_time_interval: float

func _ready():
	instance = self
	dialog_box = $DialogBox as Control
	dialog_name = $DialogBox/Name as RichTextLabel
	dialog_text = $DialogBox/Text as RichTextLabel
	tree = get_tree()


func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		return

static func show_dialog(character_name: String, dialogue: String):
	dialog_box.visible = true
	dialog_name.bbcode_text = character_name
	dialog_text.bbcode_text = dialogue

	dialog_text.visible_characters = 0
	
	while dialog_text.visible_characters < len(dialog_text.text):
		dialog_text.visible_characters += 1
		await tree.create_timer(instance.text_visual_time_interval).timeout

static func hide_dialog():
	dialog_box.visible = false
