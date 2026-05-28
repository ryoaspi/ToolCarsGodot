class_name EJDemoCarWithJoystick
extends CharacterBody3D

@export var speed : float = 4.0
@export var turn_speed : float = 3.0
@export var jump_impulse : float = 3.0

@export var forward_back : float
@export var left_right : float

var wants_to_jump : bool = false
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func set_move_with_joystick(joystick: Vector2) -> void:
	forward_back = joystick.x
	left_right = joystick.y

func _on_jump_with_left_joystick(pressed: bool) -> void:
	if pressed: 
		wants_to_jump = true
		
		
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = -0.1 

	# Left/Right
	if abs(left_right) > 0.1:
		rotate_y(-left_right * turn_speed * delta)
		
	# Forward/Backward
	var direction = Vector3.ZERO
	if abs(forward_back) > 0.1:
		direction = -transform.basis.z * forward_back

	if direction.length() > 0:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
	
		velocity.x = move_toward(velocity.x, 0, speed * 10 * delta)
		velocity.z = move_toward(velocity.z, 0, speed * 10 * delta)
		
	# Jump4Fun
	if is_on_floor() and wants_to_jump:
		velocity.y = jump_impulse
	wants_to_jump = false

	move_and_slide()
