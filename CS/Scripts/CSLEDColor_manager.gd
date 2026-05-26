@tool
class_name CSLEDColorSelection

extends MeshInstance3D

# Création du signal pour prévenir du changement de couleur
signal color_changed(newColor : Color)
## Index de la couleur à afficher (doit correspondre à la position dans la liste 'color_selection' juste en dessous)
@export var led_color: int
# Liste de couleurs personnalisables depuis l'inspecteur de Godot
@export var color_selection: Array[Color]
# Couleur de sécurité si le chiffre entré ne correspond à aucune position de la liste
@export var default_color: Color = Color(1.0, 0.0, 1.0, 1.0)
## Case à cocher pour activer/désactiver le clignotement
@export var is_blinking: bool = false
# Couleur utilisée pour le clignotement (le noir par défaut)
@export var blink_color: Color = Color(0.0, 0.0, 0.0, 1.0)
# Vitesse du clignotement (ex: 1.0 = normal, 2.0 = deux fois plus vite, 0.5 = deux fois plus lent)
@export var blink_speed: float = 1.0

# Variable interne pour compter le temps qui passe
var blink_timer: float = 0.5
# Une variable "interrupteur" : True = couleur normale, False = noir
var led_is_on: bool = true

func _ready():
	# Creation de la duplication du material car sinon ca change la couleur de tous les meshs ayant ce Material
	if get_active_material(0):
		var my_material = get_active_material(0).duplicate()
		set_surface_override_material(0, my_material)

# Permet à un autre script ou au signal d'un bouton de changer directement la couleur
func set_selection(index:int):
	led_color = index

func _process(delta):
	# Je récupère le matériau unique configuré dans le _ready
	var my_material = get_surface_override_material(0)
	
	# Si le matériau existe bien, je gère la couleur
	if my_material:
		# D'abord, je set la couleur par default qui sera changé par le résultat de la condition
		var base_color = default_color
		
		for n in range(color_selection.size()):
			# Si le chiffre de l'inspecteur (led_color) correspond à la position 'n' dans la liste,
			if led_color == n:
				# alors, je prend la couleur stockée à cet endroit précis !
				base_color = color_selection[n]
		
		# Le clignotement (est fait APRÈS la boucle pour pouvoir écraser la couleur si besoin)
		if is_blinking:
			# Le chrono descend petit à petit
			blink_timer -= delta * blink_speed
			
			# Dès que le chrono touche le sol (0 ou moins)
			if blink_timer <= 0.0:
				led_is_on = not led_is_on # On inverse l'interrupteur (True devient False, False devient True)
				blink_timer = 0.5         # On recharge le chrono pour une demi-seconde
			
			# On applique la couleur selon l'état de notre interrupteur
			if led_is_on == false:
				base_color = blink_color
		else:
			# Si on ne clignote plus, on s'assure que la LED reste allumée normalement
			led_is_on = true
			blink_timer = 0.5
			
		# Application de la couleur sur le material
		my_material.albedo_color = base_color
		
		# j'envoie l'info au reste du monde
		color_changed.emit(base_color)
