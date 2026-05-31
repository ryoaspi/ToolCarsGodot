extends Node
var car: Node
func _ready():
	print("Hello World")
func _on_received_target(target: Node):
	print("Target:", target)
	car = target
	while true:
		await get_tree().create_timer(1.0).timeout
		if !car:
			continue
		var left_color: Color = car.get_left_line_sensor_color()
		var right_color: Color = car.get_right_line_sensor_color()
		var left_green := is_green(left_color)
		var right_green := is_green(right_color)
		car.set_wheels(randf(),randf())

func is_green(c: Color) -> bool:
	return c.g > 0.6 and c.g > c.r and c.g > c.b
