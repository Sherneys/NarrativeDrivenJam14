extends Node

class_name RegisterPool

static var registers: Dictionary = {}

static func get_register(rid: int):
	if !registers.has(rid):
		registers[rid] = 0
	return registers[rid]
	
static func set_register(rid: int, value: int):
	registers[rid] = value

static func get_bool():
	if registers[1] > 0:
		return true
	return false
	
static func get_switch():
	return registers[1]

static func get_keys():
	return registers.keys()
	
static func get_day():
	return registers[2]

static func set_day(new_day: int):
	registers[2] = new_day
	
static func increase_day():
	increase_value(2)

static func increase_value(key: int):
	registers[key] = registers[key] + 1

static func decrease_value(key: int):
	registers[key] = registers[key] - 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
