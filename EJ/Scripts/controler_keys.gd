extends CharacterBody3D

@export var SPEED : float = 4
@export var TURN_SPEED : float = 3.0

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	var forward_back = Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
	var left_right = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)

#Left/Right
	if abs(left_right) > 0.1:
		rotate_y(-left_right * TURN_SPEED * delta)
#Forward/Backward
	var direction = Vector3.ZERO
	if abs(forward_back) > 0.1:
		direction = -transform.basis.z * forward_back

	if direction.length() > 0:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		velocity.z = move_toward(velocity.z, 0, SPEED * delta)

	move_and_slide()
