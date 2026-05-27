extends Node

@export var character : CharacterBody3D
@export var left_controller : XRController3D
@export var right_controller : XRController3D
@export var max_speed_forward_in_mps : float = 1
@export_range(-1,1,0.01) var joystick_move_intensity : float = 0

func set_joystick_inputs_vector2(joystick: Vector2) :
	joystick_move_intensity = joystick.y

func set_joystick_move(percentage : float) :
	joystick_move_intensity = percentage
	
func car_move(value: float):
	var position : Vector3 = character.global_position
	var car_direction : Vector3 = -character.basis.z
	car_direction.y = 0
	position = position + car_direction * max_speed_forward_in_mps * joystick_move_intensity * value
	character.global_position = position
	
func _process(delta: float) -> void:
	var left_joystick = left_controller.get_vector2("primary")
	var right_joystick = right_controller.get_vector2("primary")
	
	if left_joystick.y > 0.1 and right_joystick.y > 0.1:
		set_joystick_move(1.0)
		car_move(delta)
	elif left_joystick.y < -0.1 and right_joystick.y < -0.1:
		set_joystick_move(-1.0)
		car_move(delta)
	else:
		set_joystick_move(0.0)
		
