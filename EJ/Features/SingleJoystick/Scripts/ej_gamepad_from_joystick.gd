class_name EJGamepadFromJoystick
extends Node

signal left_joystick_updated(joystick : Vector2)
signal right_joystick_updated(joystick : Vector2)
signal jump_with_left_joystick(pressed : bool)
signal jump_with_right_joystick(pressed : bool)

@export var left_joystick : Vector2
@export var right_joystick : Vector2
@export var left_joystick_button : bool
@export var right_joystick_button : bool

func _physics_process(_delta: float) -> void:
	var forward_back = -Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
	var left_right = Input.get_joy_axis(0, JOY_AXIS_LEFT_X)
	var new_joystick_value : Vector2 = Vector2(forward_back, left_right)
	
	left_joystick_updated.emit(new_joystick_value)
	left_joystick = new_joystick_value
	
	forward_back = -Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	left_right = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
	new_joystick_value = Vector2(left_right, forward_back)
	
	right_joystick_updated.emit(new_joystick_value)
	right_joystick = new_joystick_value
	
	var jump_left = Input.is_joy_button_pressed(0, JOY_BUTTON_LEFT_STICK)
	var jump_right = Input.is_joy_button_pressed(0, JOY_BUTTON_RIGHT_STICK)
	
	left_joystick_button = jump_left
	right_joystick_button = jump_right
	
	jump_with_left_joystick.emit(jump_left)
	jump_with_right_joystick.emit(jump_right)
