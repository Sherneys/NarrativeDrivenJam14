extends Node

class_name StoryRunner

static var payloads: Dictionary = {}
static var current_id: int = 1
static var is_running = false
static var is_complete_payload = true

static var is_set_complete_when_ui_accept = false
static var is_set_complete_when_select_choice = false
static var is_set_complete_when_background_fade_complete = false
static var is_set_complete_when_char_fade_complete = false

static var choice_jump_indexs = []

static var is_end_day:bool = false
static var is_end_session: bool = false

static func add_payload(payload: StoryPayload):
	var payload_id: int = payload.id
	payloads[payload_id] = payload

static func clear_payloads():
	is_end_session = false
	current_id = 1
	payloads.clear()

static func start_run():
	is_running = true

static func override_current_id(new_id: int):
	is_set_complete_when_ui_accept = false
	is_set_complete_when_select_choice = false
	is_complete_payload = true
	current_id = new_id

func _get_register_id(argument: String):
	if argument.begins_with("RG"):
		var expected_id_str = argument.substr(2, -1)
		var expected_id = expected_id_str.to_int()
		if(expected_id > 0):
			return expected_id
	return -1

static func is_end_day_already() -> bool:
	return is_end_day
	
static func is_end_session_already() -> bool:
	return is_end_session

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_complete_payload and is_running:
		is_complete_payload = false
		if payloads.has(current_id):
			var payload: StoryPayload = payloads[current_id] 
			var command: String = payload.command
			if command == "ND" :
				var character_name = payload.arguments[0]
				var dialogue = payload.arguments[1]
				DialogSys.show_dialog(character_name, dialogue)
				current_id = current_id + 1
				is_set_complete_when_ui_accept = true
			elif command == "CD":
				choice_jump_indexs.clear()
				var choice_dialogues = []
				var character_name = payload.arguments[0]
				var dialogue = payload.arguments[1]
				DialogSys.show_dialog(character_name, dialogue)
				var argument_index: int = 2
				var choice_index: int = 1
				for argument in payload.arguments.slice(2):
					if argument_index % 2 == 0:
						choice_dialogues.append(argument)
					else:
						choice_jump_indexs.append(argument.to_int())
					argument_index += 1
					if argument_index % 2 == 0:
						choice_index += 1
				ChoiceSys.show_choices(choice_dialogues)
				is_set_complete_when_select_choice = true
			elif command == "J":
				var new_id_str: String = payload.arguments[0]
				current_id = new_id_str.to_int()
				is_complete_payload = true
			elif command == "ED":
				print("End Day")
				SaveSys.get_instance().save_register()
			elif command == "ES":
				print("End Session")
				current_id = current_id + 1
				is_complete_payload = true
			elif command == "SR":
				RegisterPool.set_register(
					payload.arguments[0].to_int(),
					payload.arguments[1].to_int()
				)
				current_id = current_id + 1
				is_complete_payload = true
			elif command == "IJ":
				if RegisterPool.get_bool():
					current_id = payload.arguments[0].to_int()
				else:
					current_id = payload.arguments[1].to_int()
				is_complete_payload = true
			elif command == "SW":
				choice_jump_indexs.clear()
				for argument in payload.arguments:
					choice_jump_indexs.append(argument.to_int())
				var selected: int = RegisterPool.get_switch()
				if selected >= choice_jump_indexs.size():
					print("ERROR: cannot switch, RG1 value is out of bound")
				else:
					current_id = choice_jump_indexs[selected]
					is_complete_payload = true
			elif command == "SC":
				CharSys.change_char_sprite(payload.arguments[0])
				current_id = current_id + 1
				is_set_complete_when_char_fade_complete = true
			elif command == "SB":
				BackgroundSys.get_instance().change_background(payload.arguments[0])
				#start hide all
				DialogSys.hide_dialog()
				ChoiceSys.hide_choice()
				#end hide all
				current_id = current_id + 1
				is_set_complete_when_background_fade_complete = true
			else:
				print("ERROR: cannot find this command name " + command)
				current_id = 0
				is_complete_payload = true
		else:
			is_end_session = true
	
	if is_set_complete_when_ui_accept and Input.is_action_just_pressed("ui_accept"):
		is_complete_payload = true
		is_set_complete_when_ui_accept = false
	
	if is_set_complete_when_select_choice:
		var is_do_complete = false
		if choice_jump_indexs.size() >= 1 and Input.is_action_just_pressed("select_choice_1"):
			current_id = choice_jump_indexs[0]
			is_do_complete = true
		if choice_jump_indexs.size() >= 2 and Input.is_action_just_pressed("select_choice_2"):
			current_id = choice_jump_indexs[1]
			is_do_complete = true
		if choice_jump_indexs.size() >= 3 and Input.is_action_just_pressed("select_choice_3"):
			current_id = choice_jump_indexs[2]
			is_do_complete = true
		if choice_jump_indexs.size() >= 4 and Input.is_action_just_pressed("select_choice_4"):
			current_id = choice_jump_indexs[3]
			is_do_complete = true
		if ChoiceSys.get_selected_choice() > 0:
			current_id = choice_jump_indexs[ChoiceSys.get_selected_choice() - 1]
			is_do_complete = true
			ChoiceSys.reset_selected_choice()
		if is_do_complete:
			is_complete_payload = true
			is_set_complete_when_select_choice = false
			ChoiceSys.hide_choice()
	
	if is_set_complete_when_background_fade_complete and BackgroundSys.get_instance().is_changing_complete:
		is_complete_payload = true
		is_set_complete_when_background_fade_complete = false
	
	if is_set_complete_when_char_fade_complete and CharSys.is_changing_complete:
		is_complete_payload = true
		is_set_complete_when_char_fade_complete = false
