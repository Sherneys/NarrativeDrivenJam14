extends Node
class_name BackgroundSys

static var instance: BackgroundSys

@export var backgrounds: Array[BackgroundRes]
@export var sprite_fader: SpriteFader

var background_dict: Dictionary

var is_changing_complete = true

static func get_instance() -> BackgroundSys:
	return instance

# Called when the node enters the scene tree for the first time.
func _ready():
	instance = self
	gen_background_dict()
	
func _process(delta):
	if !is_changing_complete and !sprite_fader.is_fade:
		is_changing_complete = true

func gen_background_dict():
	background_dict = {}
	for res in backgrounds:
		background_dict[res.id] = res.background_texture

func change_background(id: String):
	is_changing_complete = false
	sprite_fader.start_fade(background_dict[id])
