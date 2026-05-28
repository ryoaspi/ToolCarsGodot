extends Node3D

signal on_space_pressed(color:Color)
@export var _color : Color

func _process(delta: float) -> void:
	
	if Input.is_action_pressed("up"):
		global_position += Vector3(0,0,-0.5) * delta
	if Input.is_action_pressed("down"):
		global_position += Vector3(0,0,0.5) * delta
	if Input.is_action_pressed("right"):
		global_position += Vector3(0.5,0,0) * delta
	if Input.is_action_pressed("left"):
		global_position += Vector3(-0.5,0,0) * delta
	if Input.is_action_pressed("space"):
		on_space_pressed.emit(_color)
