extends Node

@export var joystick: Vector2

func set_input(joystick_given: Vector2):
	joystick = joystick_given
	print(joystick_given)
