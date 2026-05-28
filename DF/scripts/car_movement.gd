class_name DFCarMovement
extends Node

signal left_wheel_rotation(degree: float)
signal right_wheel_rotation(degree: float)

@export var character : CharacterBody3D
@export var left_controller : XRController3D
@export var right_controller : XRController3D
@export var max_speed_forward_in_mps : float = 1
@export var rotation_speed_in_degrees: float = 360
@export_range(-1,1,0.01) var joystick_move_intensity : float = 0
@export_range(-1,1,0.01) var joystick_rotation_intensity : float = 0
@export var override_input_with_xr:bool =false
@export var wheel_left: float
@export var wheel_right: float
var car_state : int = 0

func set_xr_input_on(isOn: bool):
	override_input_with_xr = isOn

func set_wheel_left(percentage : float):
	wheel_left = percentage
	
func set_wheel_right(percentage : float):
	wheel_right = percentage

func set_wheel_left_and_right(percentage_left : float, percentage_right: float):
	wheel_right = percentage_right
	wheel_left = percentage_left

func _ready() -> void:
	if character == null:
		push_warning("There is no CharacterBody3D")
	
func _process(delta: float) -> void:
	handle_car_state(wheel_left, wheel_right)
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
			set_joystick_rotation(1)
			character.rotate_y(deg_to_rad(rotation_speed_in_degrees) * delta * -joystick_rotation_intensity)
		4:
			set_joystick_rotation(1)
			character.rotate_y(deg_to_rad(rotation_speed_in_degrees) * delta * joystick_rotation_intensity)
		5:
			set_joystick_rotation(-1)
			character.rotate_y(deg_to_rad(rotation_speed_in_degrees) * delta * -joystick_rotation_intensity)
		6:
			set_joystick_rotation(-1)
			character.rotate_y(deg_to_rad(rotation_speed_in_degrees) * delta * joystick_rotation_intensity)
		7:
			set_joystick_move(0)
		8:
			set_joystick_move(0)
		9: 
			set_joystick_move(0)
			
func handle_car_state(left_joystick_percent:float,right_joystick_percent:float) -> void:
	var left_joystick :Vector2 = Vector2(0,left_joystick_percent)
	var right_joystick :Vector2 = Vector2(0,right_joystick_percent)
	if override_input_with_xr:
		left_joystick = left_controller.get_vector2("primary")
		right_joystick = right_controller.get_vector2("primary")
	
	if left_joystick.y > 0.1 and right_joystick.y > 0.1:
		car_state = 1 #Avance - Avance
	elif left_joystick.y < -0.1 and right_joystick.y < -0.1:
		car_state = 2 #Recule - Recule
	elif left_joystick.y > 0.1 and right_joystick.y == 0:
		car_state = 3 #Avance - Immobile
	elif left_joystick.y == 0 and right_joystick.y > 0.1:
		car_state = 4  #Immobile - Avance
	elif left_joystick.y < -0.1 and right_joystick.y == 0:
		car_state = 5  #Recule - Immobile
	elif left_joystick.y == 0 and right_joystick.y < -0.1:
		car_state = 6 #Immobile - Recule
	elif left_joystick.y < -0.1 and right_joystick.y > 0.1:
		car_state = 7 #Recule - Avance
	elif left_joystick.y > 0.1 and right_joystick.y < -0.1:
		car_state = 8 #Avance - Recule
	else:
		car_state = 9 #Immobile - Immobile

func set_joystick_inputs_vector2(joystick: Vector2) :
	joystick_move_intensity = joystick.y
	joystick_rotation_intensity = joystick.y

func set_joystick_move(percentage : float) :
	joystick_move_intensity = percentage
	
func set_joystick_rotation(percentage : float) :
	joystick_rotation_intensity = percentage
	
func car_move(value: float):
	var position : Vector3 = character.global_position
	var car_direction : Vector3 = -character.basis.z
	car_direction.y = 0
	position = position + car_direction * max_speed_forward_in_mps * joystick_move_intensity * value
	character.global_position = position

func car_wheels_rotate(value: float) :
	if joystick_move_intensity >= 0.1:
		left_wheel_rotation.emit(joystick_move_intensity * rotation_speed_in_degrees)
		right_wheel_rotation.emit(joystick_move_intensity * rotation_speed_in_degrees)
	else:
		left_wheel_rotation.emit(0)
		right_wheel_rotation.emit(0)
