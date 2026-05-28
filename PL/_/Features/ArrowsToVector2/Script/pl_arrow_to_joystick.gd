class_name PLArrowToJoystick
extends Node

signal joystick_updated(joystick: Vector2)

@export var joystick: Vector2

@export var arrow_up: String = "Up"
@export var arrow_down: String = "Down"
@export var arrow_left: String = "Left"
@export var arrow_right: String = "Right"

@export var use_print_debug: bool = false


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if arrow_up == event.as_text_key_label():
			if event.pressed and not event.echo:
				joystick.y = 1
				notify_change()
				if use_print_debug:
					print("Arrow UP")
			else:
				joystick.y = 0
				notify_change()

		elif arrow_down == event.as_text_key_label():
			if event.pressed and not event.echo:
				joystick.y = -1
				notify_change()
				if use_print_debug:
					print("Arrow DOWN")
			else:
				joystick.y = 0
				notify_change()

		elif arrow_left == event.as_text_key_label():
			if event.pressed and not event.echo:
				joystick.x = -1
				notify_change()
				if use_print_debug:
					print("Arrow LEFT")
			else:
				joystick.x = 0
				notify_change()
				
		elif arrow_right == event.as_text_key_label():
			if event.pressed and not event.echo:
				joystick.x = 1
				notify_change()
				if use_print_debug:
					print("Arrow RIGHT")
			else:
				joystick.x = 0
				notify_change()
	
	
func notify_change():
	joystick_updated.emit(joystick)
