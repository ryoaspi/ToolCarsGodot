extends Node


var state : int = 0

func handle_state() -> void:
	if joystick_left > 0 and joystick_right > 0:
		state = 1
	elif joystick_left < 0 and joystick_right < 0:
		state = 2
	
func _process(delta: float) -> void:
	
	match state:
		0:
			je ne bouge pas
		1:
			avance
		2:
			recule
		3: 
			va a gauche
		4: 
			va a droite

handle_state()
