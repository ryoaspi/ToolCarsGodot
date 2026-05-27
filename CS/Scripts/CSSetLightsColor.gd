class_name CSSetLightsColor
extends Node

@export var spot_lights: Array[SpotLight3D]

# Cette fonction va recevoir la couleur émise par le signal de CSLEDColorSelection
func set_color(color: Color) -> void:
	for light in spot_lights:
		if light == null:
			continue
		
		# Si le clignoteur envoie du noir, on masque le spot (gain de performances !)
		if color == Color.BLACK:
			light.visible = false
		else:
			light.visible = true
			light.light_color = color


func _on_light_color_changed(new_color: Color) -> void:
	pass # Replace with function body.
