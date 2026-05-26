extends Node


@export var name_for_up: String = "Up"
@export var name_for_down: String = "Down"
@export var name_for_left: String = "Left"
@export var name_for_right: String = "Right"

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if name_for_up == event.as_text_key_label():
			print("I'm UP key")

		elif name_for_down == event.as_text_key_label():
			print("I'm DOWN key")

		elif name_for_left == event.as_text_key_label():
			print("I'm LEFT key")

		elif name_for_right == event.as_text_key_label():
			print("I'm RIGHT key")

		else:
			print("I don`t arrow key !")
