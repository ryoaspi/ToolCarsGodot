class_name FrSnapWithNode
extends Node

signal node_found(snap_node : Node)
signal node_3D_found(snap_node : Node3D)

@export var last_send_node : Node

func send_node_variant_found(node_variant : Variant):
	if node_variant is Node:
		var node : Node = node_variant
		send_node_found(node)
func send_node_found(node: Node):
	last_send_node = node
	node_found.emit(node)
	var node3d : Node3D = node
	node_3D_found.emit(node)
