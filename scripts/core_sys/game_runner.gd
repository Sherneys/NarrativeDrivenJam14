extends Node

enum STATE {BEGIN, START_DAY, FADE_OUT_DAY, RUN_STORY, CHANGE_SESSION, FADE_IN_DAY}

@export var days: Array[DayRes]

const STORY_FILE_PATH: String = "res://assets/story/"

var day_dict: Dictionary
var current_state: STATE = STATE.BEGIN
var current_day_res: DayRes
var current_session_index: int
var current_session_res: SessionRes

func gen_day_dict():
	day_dict = {}
	for day in days:
		day_dict[day.day] = day

# Called when the node enters the scene tree for the first time.
func _ready():
	RegisterPool.set_day(1)
	gen_day_dict()

func _start_day(day: int):
	RegisterPool.set_day(day)
	current_day_res = day_dict[day]
	current_session_index = -1

func _setup_new_session():
	current_session_index += 1
	if current_session_index >= current_day_res.sessions.size():
		current_session_res = null;
	else:
		current_session_res = current_day_res.sessions[current_session_index]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var day: int = RegisterPool.get_day()
	
	if current_state == STATE.BEGIN:
		#change to start_day state
		_start_day(day)
		DaySys.get_instance().show_immedietly()
		current_state = STATE.START_DAY
	elif current_state == STATE.START_DAY:
		if Input.is_action_just_pressed("left_click") || Input.is_action_just_pressed("ui_accept"):
			DaySys.get_instance().hide_fade_out()
			current_state = STATE.FADE_OUT_DAY
	elif current_state == STATE.FADE_OUT_DAY:
		if DaySys.get_instance().is_changing_complete:
			print("start run story")
			current_state = STATE.CHANGE_SESSION
	elif current_state == STATE.CHANGE_SESSION:
		_setup_new_session()
		if current_session_res == null:
			_start_day(day + 1)
			DaySys.get_instance().show_fade_in()
			current_state = STATE.FADE_IN_DAY
		else:
			StoryReader.read_CSV(STORY_FILE_PATH + current_session_res.story_file_name)
			StoryRunner.start_run()
			current_state = STATE.RUN_STORY
	elif current_state == STATE.RUN_STORY:
		if StoryRunner.is_end_session_already():
			current_state = STATE.CHANGE_SESSION
	elif current_state == STATE.FADE_IN_DAY:
		if DaySys.get_instance().is_changing_complete:
			print("Start new day")
			current_state = STATE.START_DAY
