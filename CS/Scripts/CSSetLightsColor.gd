@tool
class_name CSSetLightsColor
extends Node

## Je glisse ici la ou les lumière(s) (Light3D) que je veux synchroniser avec cette LED.
@export var spot_lights: Array[SpotLight3D]

func set_color(color: Color) -> void:
	# Cette fonction est appelée automatiquement quand elle reçoit le signal 'color_changed'.
	
	# Je passe en revue chaque lumière que j'ai glissée dans mon tableau.
	for light in spot_lights:
		# Si une case de mon tableau est vide, je l'ignore pour ne pas faire planter le script.
		if light == null:
			continue
		
		# Si la couleur que je reçois est totalement noire, cela signifie que la lumière est éteinte.
		if color == Color.BLACK:
			# Je masque la lumière complètement. Cela permet à l'ordinateur de ne pas calculer de lumière pour rien.
			light.visible = false
		else:
			# Si la couleur n'est pas noire, je m'assure que la lumière est bien visible.
			light.visible = true
			# J'applique la nouvelle couleur reçue à ma lumière 3D.
			light.light_color = color
