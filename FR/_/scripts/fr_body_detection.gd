class_name FrBodyDetection
extends Node

signal rigid_body_found(body_found : RigidBody3D)
signal character_body_found(body_found : CharacterBody3D)
signal vehicle_body_found(body_found : VehicleBody3D)
signal other_found(node_found : Node)

@export var body_detected : Node
@export var target_area : Area3D

func _ready() -> void:
	target_area.body_entered.connect(_on_body_entered)
	target_area.body_exited.connect(_on_body_exited)
	target_area.area_entered.connect(_on_area_entered)
	target_area.area_exited.connect(_on_area_exited)

func _on_body_entered(body: Node3D) -> void:
	body_detection(body)

func _on_body_exited(body: Node3D) -> void:
	if body == body_detected:
		body_detected = null

func _on_area_entered(area: Area3D) -> void:
	body_detection(area)

func _on_area_exited(area: Area3D) -> void:
	if area == body_detected:
		body_detected = null

func body_detection(node: Node) -> void:
	if node == self:
		return

	if node is VehicleBody3D:
		# VehicleBody3D must be checked BEFORE RigidBody3D
		# because VehicleBody3D extends RigidBody3D
		body_detected = node
		emit_signal("vehicle_body_found", node as VehicleBody3D)
		if node is RigidBody3D:
			body_detected = node
			rigid_body_found.emit(node)
	elif node is CharacterBody3D:
		body_detected = node
		character_body_found.emit(node)
	elif node is RigidBody3D:
			body_detected = node
			rigid_body_found.emit(node)
	else: 
		other_found.emit(node)
