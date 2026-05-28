extends Node

@export var character : CharacterBody3D
@export var left_controller : XRController3D
@export var right_controller : XRController3D
var left_joystick = left_controller.get_vector2("primary")
var right_joystick = right_controller.get_vector2("primary")
@export var max_speed_forward_in_mps : float = 1
@export_range(-1,1,0.01) var joystick_move_intensity : float = 0

var car_state : int = 0
	
func _process(delta: float) -> void:
	match car_state:
		0:
			set_joystick_move(0)
		1: 
			set_joystick_move(1)
			car_move(delta)
		2: 
			set_joystick_move(-1)
			car_move(delta)
		3:
			set_joystick_move(0)
		4:
			set_joystick_move(0)
		5:
			set_joystick_move(0)
		6:
			set_joystick_move(0)
		7:
			set_joystick_move(0)
		8:
			set_joystick_move(0)

func handle_car_state() -> void:
	if left_joystick.y > 0.1 and right_joystick.y > 0.1:
		car_state = 1
	elif left_joystick.y < -0.1 and right_joystick.y < -0.1:
		car_state = 2
	elif left_joystick.y > 0.1 and right_joystick.y == 0:
		car_state = 3
	elif left_joystick.y == 0 and right_joystick.y > 0.1:
		car_state = 4
	elif left_joystick.y < -0.1 and right_joystick.y == 0:
		car_state = 5
	elif left_joystick.y == 0 and right_joystick.y < -0.1:
		car_state = 6
	elif left_joystick.y == 0 and right_joystick.y < -0.1:
		car_state = 7
	else:
		car_state = 8
	handle_car_state()

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
