class_name EJMenu
extends Node

@export var menu_scene: PackedScene

@export_group("Configuration Clavier")
@export var keyboard_menu: Key = KEY_ESCAPE

@export_group("Configuration Manette")
@export var use_gamepad: bool = true
@export var gamepad_menu: JoyButton = JOY_BUTTON_START 
var menu_instance: Control = null 

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.is_echo():
		if event.keycode == keyboard_menu:
			toggle_menu()
			
	if use_gamepad and event is InputEventJoypadButton and event.pressed and not event.is_echo():
		if event.button_index == gamepad_menu:
			toggle_menu()

func toggle_menu() -> void:
	if is_instance_valid(menu_instance):
		menu_instance.queue_free()
		get_tree().paused = false
		
	if menu_scene:
			menu_instance = menu_scene.instantiate()
			add_child(menu_instance)
			get_tree().paused = true
