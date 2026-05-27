@tool
class_name CSLEDColorSelection
extends MeshInstance3D

# Création du signal pour prévenir le reste du jeu du changement de couleur
signal color_changed(newColor : Color)

## Index de la couleur à afficher (doit correspondre à la position dans la liste 'color_selection' juste en dessous)
@export var led_color: int:
	set (value):
		led_color = value
		# SÉCURITÉ POUR @TOOL : On ne rafraîchit que si le node est complètement prêt dans l'éditeur.
		# Cela évite que refresh() ne crash au chargement du projet.
		if is_node_ready():
			refresh()

# Liste de couleurs personnalisables depuis l'inspecteur de Godot
@export var color_selection: Array[Color]

# Couleur de sécurité si le chiffre entré ne correspond à aucune position de la liste
@export var default_color: Color = Color(0.0, 0.0, 0.0, 1.0)


func _ready():
	# Création de la duplication du matériau car sinon ça change la couleur de tous les meshs ayant ce Material
	if get_active_material(0):
		var my_material = get_active_material(0).duplicate()
		set_surface_override_material(0, my_material)
	
	# On force un premier rafraîchissement une fois que le matériau unique est bien en place
	refresh()


# Permet à un autre script ou au signal d'un bouton de changer directement la couleur
func set_selection(index: int):
	# Assigner la valeur déclenche automatiquement le "set(value)" du haut,
	# qui lui-même appelle déjà refresh().
	led_color = index


# Fonction passerelle qui permet à un script externe (ex: le clignoteur) de forcer 
# une couleur spécifique directement (comme le noir) sans toucher à l'index de base
func set_forced_color(custom_color: Color):
	var my_material = get_surface_override_material(0)
	if my_material:
		my_material.albedo_color = custom_color
		color_changed.emit(custom_color)


func refresh():
	# Je récupère le matériau unique configuré dans le _ready
	var my_material = get_surface_override_material(0)
	
	# Si le matériau existe bien, je gère la couleur
	if my_material:
		# D'abord, je définis la couleur par défaut (sécurité), qui sera modifiée si la condition est remplie
		var base_color = default_color
		
		for n in range(color_selection.size()):
			# Si le chiffre de l'inspecteur (led_color) correspond à la position 'n' dans la liste
			if led_color == n:
				# Alors, je prends la couleur stockée à cet endroit précis !
				base_color = color_selection[n]
			
		# Application physique de la couleur sur le composant Albedo du matériau
		my_material.albedo_color = base_color
		
		# J'envoie l'info au reste du monde
		color_changed.emit(base_color)
