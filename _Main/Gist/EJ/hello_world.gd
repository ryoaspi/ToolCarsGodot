extends Node


func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	pass


func _on_car_received(car_node: Node):
	print(car_node)
	print("Hello Mod")
