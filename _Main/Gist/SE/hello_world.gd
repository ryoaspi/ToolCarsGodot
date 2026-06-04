extends Node

var car: Node
var target_light: Node = null
var following_light := false
var search_mode := true
var random_direction := 1.0
var random_timer := 0.0
var random_duration := 0.0

func _ready():
	print("Check if DeepSeek, can play the game.")

func _physics_process(delta):
	if !car:
		return
	if random_timer > 0:
		random_timer -= delta
	
	if following_light and target_light:
		follow_light()
	else:
		search_for_green_light()

func _on_received_target(target: Node):
	print("Target:", target)
	car = target

func search_for_green_light():
	var left_color: Color = car.get_left_line_sensor_color()
	var right_color: Color = car.get_right_line_sensor_color()
	var left_green := is_green(left_color)
	var right_green := is_green(right_color)
	if left_green and right_green:
		car.set_wheels(0.8, 0.8)
		var light_strength = max(left_color.g, right_color.g)
		if light_strength > 0.8:
			following_light = true
			target_light = car  # Following the green light path
			
	elif left_green:
		car.set_wheels(0.3, 0.8)
		
	elif right_green:
		car.set_wheels(0.8, 0.3)
		
	else:
		move_randomly()

func move_randomly():
	if random_timer <= 0:
		random_direction = randf_range(-1.0, 1.0)
		random_duration = randf_range(0.5, 2.0)
		random_timer = random_duration
	var left_speed: float
	var right_speed: float
	
	if random_direction > 0:
		left_speed = 0.5
		right_speed = 0.5 - random_direction * 0.5
	else:
		left_speed = 0.5 + random_direction * 0.5
		right_speed = 0.5
	if randf() < 0.02:  # 2% chance per frame to reverse
		left_speed = -0.3
		right_speed = -0.3
	
	car.set_wheels(left_speed, right_speed)

func follow_light():
	var left_color: Color = car.get_left_line_sensor_color()
	var right_color: Color = car.get_right_line_sensor_color()
	var front_color: Color = car.get_front_sensor_color() if car.has_method("get_front_sensor_color") else Color.BLACK
	var left_green := is_green(left_color)
	var right_green := is_green(right_color)
	var front_green := is_green(front_color) if car.has_method("get_front_sensor_color") else false
	
	if front_green and (left_green or right_green):
		car.set_wheels(1.0, 1.0)
		if get_light_intensity(front_color) > 0.9:
			print("Reached the green light!")
			car.set_wheels(0.0, 0.0)
			
	elif left_green and right_green:
		car.set_wheels(0.9, 0.9)
		
	elif left_green:
		car.set_wheels(0.2, 0.9)
		
	elif right_green:
		car.set_wheels(0.9, 0.2)
		
	else:
		following_light = false
		target_light = null
		search_mode = true

func is_green(c: Color) -> bool:
	return c.g > 0.6 and c.g > c.r and c.g > c.b

func get_light_intensity(c: Color) -> float:
	return c.g
