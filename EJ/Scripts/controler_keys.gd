extends Node3D

func _input(event: InputEvent) -> void:
	move_forward(event)
	move_backward(event)
	turn_left(event)
	turn_right(event)
	
func move_forward(event: InputEvent) -> void:
	if event is InputEventJoypadMotion:
		if event.axis == JOY_AXIS_LEFT_Y and event.axis_value <= -0.1:
			print_debug("Forward")

func move_backward(event: InputEvent) -> void:
	if event is InputEventJoypadMotion:
		if event.axis == JOY_AXIS_LEFT_Y and event.axis_value >= 0.1:
			print_debug("Backward")
			
func turn_left(event: InputEvent) -> void:
	if event is InputEventJoypadMotion:
		if event.axis == JOY_AXIS_RIGHT_X and event.axis_value <= -0.1:
			print_debug("Left")

func turn_right(event: InputEvent) -> void:
	if event is InputEventJoypadMotion:
		if event.axis == JOY_AXIS_RIGHT_X and event.axis_value >= 0.1:
			print_debug("Right")
	
	
	
#if Input.is_action_pressed("move_forward"):
		#print_debug("Forward")
		
	#if Input.is_action_pressed("move_backward"):
		#print_debug("Backward")
		
	#if Input.is_action_pressed("turn_left"):
		#print_debug("left")
		
	#if Input.is_action_pressed("turn_right"):
		#print_debug("right")
