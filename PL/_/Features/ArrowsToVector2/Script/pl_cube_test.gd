extends Node

signal joystick_debug_as_string(text: String)

@export var joystick: Vector2


func set_input(joystick_given: Vector2):
	joystick = joystick_given
	joystick_debug_as_string.emit(str(joystick_given))
	print(joystick_given)
