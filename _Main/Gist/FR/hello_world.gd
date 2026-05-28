extends Node


func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	pass


func _on_car_received(car_node: Node):
	print("🚗 Car connected to KS4036 node!")
	print("📦 Attached node: ", car_node)
