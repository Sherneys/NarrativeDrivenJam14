extends CharacterBody2D

class_name Card

@export var sprite2D: Sprite2D
@export var slide_velocity_multiplier: float = 5

var is_slide: bool = false
var card_res: TarotCardRes
var after_slide_spawn_position: Vector2

func setup(card_res: TarotCardRes, after_slide_spawn_position: Vector2):
	is_slide = true
	self.card_res = card_res
	sprite2D.texture = self.card_res.card_texture
	self.after_slide_spawn_position = after_slide_spawn_position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_slide:
		velocity = (after_slide_spawn_position - position) * slide_velocity_multiplier
		if abs(velocity.length()) < 50:
			is_slide = false
	move_and_slide()
