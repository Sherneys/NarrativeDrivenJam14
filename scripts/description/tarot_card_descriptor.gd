extends Node

class_name TarotCardDescriptor

@export var shower_control:Control
@export var card_name_label: Label
@export var card_description_label: RichTextLabel
@export var card: Card
@export var drag_sys: DragSys

var is_show: bool = true

func show(card_name: String, card_description: String):
	if is_show:
		return
	is_show = true
	shower_control.visible = true
	card_name_label.text = card_name
	card_description_label.text = card_description

func hide():
	if !is_show:
		return
	is_show = false
	shower_control.visible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_card_deck_mouse_entered():
	show(card.card_res.card_name, card.card_res.card_description)


func _on_card_deck_mouse_exited():
	if drag_sys.current_state != DragSys.STATE.DRAGGED:
		hide()
