extends Node2D

class_name DaySys

static var instance: DaySys

const DAY_SHOW_START_TEXT:String = "Day "

@export var blackScreenTexture: Texture
@export var sprite_fader: SpriteFader
@export var day_label: Label

var is_changing_complete = true
var is_show = true
var current_day: int = 1

static func get_instance() -> DaySys:
	return instance

func show_fade_in():
	is_changing_complete = false
	sprite_fader.start_fade(blackScreenTexture)
	is_show = true

func show_immedietly():
	sprite_fader.change_immedietly(blackScreenTexture)
	is_show = true

func hide_fade_out():
	is_changing_complete = false
	sprite_fader.start_fade(null)
	is_show = false
	
func hide_immedietly():
	sprite_fader.change_immedietly(null)
	is_show = false
	
func _ready():
	instance = self
	
func _process(delta):
	if !is_changing_complete and !sprite_fader.is_fade:
		is_changing_complete = true
	if is_changing_complete and is_show:
		day_label.text = DAY_SHOW_START_TEXT + str(RegisterPool.get_day())
	else:
		day_label.text = ""

