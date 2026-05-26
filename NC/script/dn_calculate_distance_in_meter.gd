class_name Dn_Calculate_Distance_In_Meter

extends Node

signal calculate_distance_on_raycast_touch_collider(distance_in_meter: float)
signal get_collider_on_raycast_touch_collider(collider_node: Node3D)

@export_group("Node Initialisation")
@export var raycast_sensor_forward: RayCast3D
@export var sensor: Node3D

@export_group("Parameters")
@export_range(0.5,10,0.5) var raycast_max_distance: float = 5

var old_raycast_max_distance_value: float

func _ready() -> void:
	raycast_sensor_forward.target_position = Vector3.FORWARD * raycast_max_distance
	old_raycast_max_distance_value = raycast_max_distance
func _process(delta: float) -> void:
	
	var distance_in_meter: float = _calculate_distance()
	var collider_hit: Node3D = _get_object_touched()
	if(distance_in_meter > 0):
		calculate_distance_on_raycast_touch_collider.emit(distance_in_meter)
	if(collider_hit):
		get_collider_on_raycast_touch_collider.emit(collider_hit)
	if(old_raycast_max_distance_value != raycast_max_distance):
		raycast_sensor_forward.target_position = Vector3.FORWARD * raycast_max_distance
		print("value changed")
		old_raycast_max_distance_value = raycast_max_distance
	
	
func _calculate_distance() -> float:
	if !raycast_sensor_forward.is_colliding():
		return -1
	var collider_hit: Object = raycast_sensor_forward.get_collider()
	var target_hit_point: Vector3 = raycast_sensor_forward.get_collision_point()
	var my_position: Vector3 = sensor.position
	var distance_in_vector3: Vector3 = target_hit_point - my_position;
	var distance_in_meter: float = distance_in_vector3.length()
	return distance_in_meter

func _get_object_touched() -> Node3D:
	if !raycast_sensor_forward.is_colliding():
		return null
	var collider_hit: Node3D = raycast_sensor_forward.get_collider()
	return collider_hit
