extends Node3D

@export var pivot: Node3D
@export var reverse_rotation: bool
@export var actual_rotation : float

func set_rotation_with_degrees(degrees: float):
	actual_rotation = degrees
	
func _process(delta: float) -> void:
	var multiple: float = 1 if reverse_rotation else -1
	pivot.rotate_x(deg_to_rad(actual_rotation * delta * multiple))
