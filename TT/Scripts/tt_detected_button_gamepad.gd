extends Node

func _input(event:InputEvent) -> void:
	if event is InputEventJoypadButton:
		print(event.pressed)
		print(event.button_index)
		if event.button_index == 9 :
			print("Left")
		if event.button_index == 10 : 
			print("Right")
	
	if event is InputEventJoypadMotion :
		if event.axis_value == 1:
			print(event.axis_value)
			print(event.axis)
			if event.axis == 5:
				print("Hello")
			if event.axis == 4:
				print ("Goodbye")
