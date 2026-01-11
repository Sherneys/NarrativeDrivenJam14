extends Node

class_name SpriteFader

@export var sprite2D: Sprite2D
@export var oldSprite2D: Sprite2D
@export var fade_timer: Timer
@export var fade_time: float
@export var first_texture: Texture

var is_fade: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	sprite2D.texture = first_texture
	oldSprite2D.texture = null


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_fade:
		var alpha: float = fade_timer.time_left / fade_time
		oldSprite2D.modulate = Color(1, 1, 1, alpha)
		sprite2D.modulate = Color(1, 1, 1, 1 - alpha)

func start_fade(new_texture: Texture):
	is_fade = true
	
	oldSprite2D.modulate = Color(1, 1, 1, 1)
	oldSprite2D.texture = sprite2D.texture
	sprite2D.texture = new_texture
	sprite2D.modulate = Color(1, 1, 1, 0)
	
	fade_timer.start(fade_time)
	
func change_immedietly(new_texture: Texture):
	sprite2D.texture = new_texture

func _on_timer_timeout():
	is_fade = false
	fade_timer.stop()
	oldSprite2D.modulate = Color(1, 1, 1, 0)
	sprite2D.modulate = Color(1, 1, 1, 1)
