extends Node

@export var car : Node3D

@export var speed : float = 8.0
@export var rotation_speed : float = 2.5

var accelerate : float = 0.0
var brake : float = 0.0

var turn_left : bool = false
var turn_right : bool = false


func _physics_process(delta: float) -> void:

	var throttle = accelerate - brake

	# Rotation continue
	if turn_left:
		car.rotate_y(rotation_speed * delta)

	if turn_right:
		car.rotate_y(-rotation_speed * delta)

	# Direction avant
	var forward := -car.transform.basis.z

	# Déplacement
	car.position += forward * throttle * speed * delta


func _input(event: InputEvent) -> void:

	# Gâchettes
	if event is InputEventJoypadMotion:

		# L2
		if event.axis == 4:
			brake = event.axis_value

		# R2
		if event.axis == 5:
			accelerate = event.axis_value


	# Boutons
	if event is InputEventJoypadButton:

		# L1
		if event.button_index == 9:
			turn_left = event.pressed

		# R1
		if event.button_index == 10:
			turn_right = event.pressed
