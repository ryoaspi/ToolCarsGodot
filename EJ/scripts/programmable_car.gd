extends Node3D
class_name ProgrammableCar

@export var move_distance: float = 2.0
@export var turn_angle: float = 45.0
@export var acceleration_step: float = 1.0
@export var max_speed: float = 8.0

var current_speed: float = 2.0

func execute_command(command: String) -> void:
	match command:
		"forward":
			move_forward()
		"back":
			move_back()
		"right":
			turn_right()
		"left":
			turn_left()
		"accelerate":
			accelerate()
		"brake":
			brake()
		_:
			print("Unknown command: ", command)

func move_forward() -> void:
	global_position += -global_transform.basis.z * move_distance

func move_back() -> void:
	global_position += global_transform.basis.z * move_distance

func turn_right() -> void:
	rotate_y(deg_to_rad(-turn_angle))

func turn_left() -> void:
	rotate_y(deg_to_rad(turn_angle))

func accelerate() -> void:
	current_speed = min(current_speed + acceleration_step, max_speed)
	move_distance = current_speed
	print("Speed: ", current_speed)

func brake() -> void:
	current_speed = max(current_speed - acceleration_step, 0.0)
	move_distance = current_speed
	print("Speed: ", current_speed)


func _on_screen_coding_command_submitted(command: String) -> void:
	execute_command(command)
