extends PanelContainer
class_name ChoiceSys

signal on_select(index)

static var container: Control
static var choice_buttons: Control
static var selected_choice:int = 0


func _ready():
	container = $MarginContainer
	choice_buttons = $MarginContainer/Choices
	hide_choice()

static func show_choices(choices:Array):
	var buttons = choice_buttons.get_children()
	for i in range(4):
		buttons[i].visible = false
	for i in range(len(choices)):
		buttons[i].text = choices[i]
		buttons[i].visible = true
	container.visible = true
	
static func hide_choice():
	container.visible = false

func _on_button_1_button_down():
	on_select.emit(1)
	selected_choice = 1


func _on_button_2_button_down():
	on_select.emit(2)
	selected_choice = 2

func _on_button_3_button_down():
	on_select.emit(3)
	selected_choice = 3
	
static func reset_selected_choice():
	selected_choice = 0
	
static func get_selected_choice():
	return selected_choice
