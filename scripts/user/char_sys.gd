extends Node
class_name CharSys

var char_dict: Dictionary
@export var characters: Array[CharRes]
@export var sprite_fader: SpriteFader

static var instance: CharSys 
static var is_changing_complete: bool = true

func gen_char_dict():
	char_dict = {}
	for res in characters:
		char_dict[res.id] = res.character_texture

static func change_char_sprite(id: String):
	is_changing_complete = false
	instance.sprite_fader.start_fade(instance.char_dict[id])

# Called when the node enters the scene tree for the first time.
func _ready():
	instance = self
	gen_char_dict()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_changing_complete and !sprite_fader.is_fade:
		is_changing_complete = true
