extends Node


func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	pass


func _on_car_received(car_node: Node):
	print("🚗 Car connected to KS4036 node!")
	print("📦 Attached node: ", car_node)
	print("")
	print("📖 Tip:")
	print("   Open the game manual and explore the scripts")
	print("   to discover how to control the vehicle.")
	print("")
	print("🛠 Available hardware:")
	print("   • Distance sensor (front)")
	print("   • 2 line-tracking color sensors")
	print("   • 2 RGB LEDs")
	print("   • 2 motorized wheels")
	print("")
	print("🎮 Control:")
	print("   Use Vector2 value to drive and steer the car.")
	print("   Use Input System if you plan to drive the car as a human.")
