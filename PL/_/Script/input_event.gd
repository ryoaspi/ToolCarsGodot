extends Node


@export var arrow_up: bool
@export var arrow_down: String = "Down"
@export var arrow_left: String = "Left"
@export var arrow_right: bool

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if arrow_up == event.is_action_pressed("ui_up"):
			print("I'm UP key")
		elif arrow_up == event.is_action_released("ui_up"):
			print("Je suis relaché")
#
		#elif arrow_down == event.as_text_key_label():
			#print("I'm DOWN key")
#
		#elif arrow_left == event.as_text_key_label():
			#print("I'm LEFT key")
#
		#elif arrow_right == event.as_text_key_label():
			#print("I'm RIGHT key")
#
		#else:
			#print("I don`t arrow key !")

var speed: float = 0.1
var position:float = 0.1

func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		# Move as long as the key/button is pressed.
		position.x += speed * delta
