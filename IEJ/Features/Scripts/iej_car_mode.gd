extends Node

var timer: float = 0.0


func _ready() -> void:
	print("User code started.")
	print("You can write your code inside _ready() or _process().")


func _process(delta: float) -> void:
	timer += delta

	

func _on_car_received(car: Node):
	print(car)
