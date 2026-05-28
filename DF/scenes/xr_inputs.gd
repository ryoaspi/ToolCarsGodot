extends Node

signal right_hand_joystick_update(joystick_r:Vector2)
signal left_hand_joystick_update(joystick_l:Vector2)

@export var left_controller : XRController3D
@export var right_controller : XRController3D

func get_right_joystick_2d_value() -> Vector2:
	if not right_controller:
		return Vector2.ZERO
	for name in ["primary", "thumbstick", "joystick", "secondary"]:
		var value = right_controller.get_vector2(name)
		if value.length() > 0.01:   # small deadzone
			return value
	return Vector2.ZERO
	
func get_left_joystick_2d_value() -> Vector2:
	if not left_controller:
		return Vector2.ZERO
	for name in ["primary", "thumbstick", "joystick", "secondary"]:
		var value = left_controller.get_vector2(name)
		if value.length() > 0.01:   # small deadzone
			return value
	return Vector2.ZERO
