class_name EjDemoCarWithJoystick
extends CharacterBody3D

@export var speed : float = 4
@export var turn_speed : float = 3.0
@export var jump_impulse = 3

@export var forward_back : float
@export var left_right : float

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func set_move_with_joystick(joystick: Vector2) :
	forward_back = joystick.x
	left_right = joystick.y

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

#Left/Right
	if abs(left_right) > 0.1:
		rotate_y(-left_right * turn_speed * delta)
#Forward/Backward
	var direction = Vector3.ZERO
	if abs(forward_back) > 0.1:
		direction = -transform.basis.z * forward_back

	if direction.length() > 0:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
		velocity.z = move_toward(velocity.z, 0, speed * delta)
	#Jump4Fun
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_impulse

	move_and_slide()
