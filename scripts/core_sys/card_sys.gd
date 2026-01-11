extends CharacterBody2D
class_name CardSys

@export var spawn_offset_x: float
@export var max_click_to_draw_time: float
@export var timer: Timer
@export var drag_sys: DragSys
var is_mouse_over: bool = false
var position_first
var is_draw:bool = true
var is_draged: bool = false
var is_mouse_over_deck: bool = false
var is_mouse_over_table: bool = false
var card_demo = preload("res://prefabs/card_1.tscn")
var demo_card_res:TarotCardRes = preload("res://resources/tarot_card/0_the_fool.tres")
var is_movable:bool = false
#var card_list = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22]
#var card_now = card_list.duplicate(true)

func _process(delta):
	if is_mouse_over_deck and Input.is_action_just_pressed("left_click"):
		timer.start(max_click_to_draw_time)
		is_movable = false
	if !is_movable and Input.is_action_just_released("left_click") and drag_sys.current_state == DragSys.STATE.DRAGGED:
		timer.stop()
		draw_card(null)
	if is_movable and is_mouse_over_table:
		move_and_slide()

func _on_card_deck_mouse_entered():
	is_mouse_over_deck = true

func _on_card_deck_mouse_exited():
	is_mouse_over_deck = false

func _on_table_area_mouse_entered():
	is_mouse_over_table = true

func _on_table_area_mouse_exited():
	is_mouse_over_table = false
	is_draged = false
	DragSys.already_drag = false

func _on_timer_timeout():
	print("time out")
	is_movable = true

func draw_card(card_now):
	randomize()
	#var card = card_now[randi()% card_now.size()]
	var card = card_demo
	var card_ready:Card = card.instantiate() as Card
	get_tree().current_scene.add_child(card_ready)
	
	var spawn_translate_vector: Vector2 = Vector2(0, 0)
	if position.x > get_viewport().size.x / 2:
		spawn_translate_vector = Vector2(-spawn_offset_x, 0)
	else:
		spawn_translate_vector = Vector2(spawn_offset_x, 0)
	card_ready.position = position
	card_ready.setup(demo_card_res, position + spawn_translate_vector)

#func shuffle_card(card_now):
	#var card_now = card_list.duplicate(true)
	#show some animation
	
func _on_button_pressed():
	#shuffle_card()
	pass


