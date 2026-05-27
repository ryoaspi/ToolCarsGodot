@tool
class_name CSLEDColorSelection
extends Node

# Le signal qui va propager la couleur au peintre et à l'électricien
signal color_changed(new_color: Color)

@export var led_color: int:
	set(value):
		led_color = value
		if is_node_ready():
			refresh()

@export var color_selection: Array[Color]
@export var default_color: Color = Color(1.0, 0.0, 1.0, 1.0)

func _ready():
	refresh()

func set_selection(index: int):
	led_color = index

# Appelé par le clignoteur pour envoyer la couleur fluide (lerp)
func set_forced_color(custom_color: Color):
	color_changed.emit(custom_color)

func refresh():
	var base_color = default_color
	if led_color >= 0 and led_color < color_selection.size():
		base_color = color_selection[led_color]
	
	# On envoie la couleur à tous ceux qui écoutent
	color_changed.emit(base_color)
