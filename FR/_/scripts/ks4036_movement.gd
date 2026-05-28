extends Node

signal	wheel_rotation_in_percent_left(percentage: float)
signal	wheel_rotation_in_percent_right(percentage: float)
@export var object_movement: CharacterBody3D
@export var speed_forward_ms: float = 0.5
@export_range(-1,1,0.1) var joystick_intensity: float = 0
@export var speed_rotation_degree: float = 180
@export_range(-1,1,0.1) var joystick_rotation_intensity: float = 0
@export var joystick_deadzone: float = 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if object_movement == null:
		push_warning("object_movement not found")
func set_joystick_forward(percentage: float):
	joystick_intensity = percentage

func set_joystick_rotate(percentage: float):
	joystick_rotation_intensity = percentage

func set_joystick_with_vector2(joystick: Vector2):
	joystick_rotation_intensity = joystick.x
	joystick_intensity = joystick.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var position: Vector3 = object_movement.position
	var direction_forward: Vector3 = -object_movement.basis.z
	direction_forward.y = 0
	position = position + direction_forward * delta * speed_forward_ms * joystick_intensity
	object_movement.position = position
	object_movement.rotate_y(-deg_to_rad(speed_rotation_degree)*delta*joystick_rotation_intensity)
	if joystick_intensity < joystick_deadzone:
		var right_wheel = abs(joystick_intensity)
		wheel_rotation_in_percent_right.emit(right_wheel)
	if joystick_intensity > joystick_deadzone:
		var left_wheel = abs(joystick_intensity)
		wheel_rotation_in_percent_left.emit(left_wheel)
	
	
	
	
	
	
