class_name IEJModLinkUnlinkNodesAsChildren
extends Node

@export var what_to_link: Array[Node]
@export var where_to_store_when_unlink: Node


func link_to_node(node: Node) -> void:
	for n in what_to_link:
		if n:
			n.reparent(node, true)


func unlink(_node: Node = null) -> void:
	for n in what_to_link:
		if n and where_to_store_when_unlink:
			n.reparent(where_to_store_when_unlink, true)


func _on_mod_runner_on_created_node(node_created: Node) -> void:
	pass # Replace with function body.


func _on_mod_runner_on_destroy_previous_node_start(node: Node) -> void:
	pass # Replace with function body.
