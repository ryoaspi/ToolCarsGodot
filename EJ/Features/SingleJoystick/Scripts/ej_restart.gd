class_name EJRestart
extends Node

@export_group("Configuration Clavier")
@export var keyboard_restart: Key = KEY_R

@export_group("Configuration Manette")
@export var use_gamepad: bool = true
@export var gamepad_restart: JoyButton = JOY_BUTTON_BACK 

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.is_echo():
		if event.keycode == keyboard_restart:
			restart_scene()
			
	if use_gamepad and event is InputEventJoypadButton and event.pressed and not event.is_echo():
		if event.button_index == gamepad_restart:
			restart_scene()

func restart_scene() -> void:
	print("restart")
	get_tree().reload_current_scene()
