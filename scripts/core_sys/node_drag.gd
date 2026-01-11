extends Node2D
class_name DragSys

@export var target_char: CharacterBody2D
@export var velocity_multiplier:float = 1
@export var velocity_decrease_rate: float = 1

var is_draw:bool = true
var is_draged: bool = false
var is_mouse_over: bool = false
var mouse_release_position: Vector2
var current_state: STATE = STATE.BEGIN
var override_position: Vector2
static var already_drag: bool = false

enum STATE {BEGIN, DRAGGED, UNDRAGGED, OVERRIDED}

func _process(delta):
	if current_state == STATE.DRAGGED and Input.is_action_just_released("left_click"):
		mouse_release_position = get_viewport().get_mouse_position()
	if is_mouse_over and Input.is_action_pressed("left_click") and !already_drag:
		already_drag = true
		current_state = STATE.DRAGGED
	else:
		if current_state == STATE.DRAGGED and !Input.is_action_pressed("left_click"):
			current_state = STATE.UNDRAGGED
			already_drag = false
	if current_state == STATE.BEGIN:
		target_char.velocity = Vector2(0, 0)
	elif current_state == STATE.DRAGGED:
		var velocity: Vector2 = (get_viewport().get_mouse_position() - target_char.position) * velocity_multiplier
		target_char.velocity = velocity
	elif current_state == STATE.UNDRAGGED:
		var velocity: Vector2 = (mouse_release_position - target_char.position) * velocity_multiplier
		target_char.velocity = velocity
	elif current_state == STATE.OVERRIDED:
		var velocity: Vector2 = (override_position - target_char.position) * velocity_multiplier
		target_char.velocity = velocity

func _on_area_2d_mouse_entered():
	is_mouse_over = true


func _on_area_2d_mouse_exited():
	is_mouse_over = false
	
func start_override_movement(override_position: Vector2):
	self.override_position = override_position
	current_state = STATE.OVERRIDED
