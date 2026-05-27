@tool
class_name CSLEDColorSelection
extends MeshInstance3D

# Création du signal pour prévenir du changement de couleur
signal color_changed(newColor : Color)

## Index de la couleur à afficher (doit correspondre à la position dans la liste "Color Selection" ci-dessous)
@export var led_color: int:
	set (value):
		led_color = value
		# SÉCURITÉ POUR @TOOL : On ne rafraîchit que si le node est complètement prêt dans l'éditeur.
		# Cela évite que refresh() ne crash au chargement du projet.
		if is_node_ready():
			refresh()

# Liste de couleurs personnalisables depuis l'inspecteur de Godot
@export var color_selection: Array[Color]

## Couleur de sécurité si le chiffre entré dans "Led Color" ne correspond à aucune position de la liste
@export var default_color: Color = Color(1.0, 0.0, 1.0, 1.0)

## Activer ou désactiver l'émission sur le matériau
@export var use_emission: bool = true:
	set(value):
		use_emission = value
		if is_node_ready():
			refresh()

## Light à synchroniser avec la LED
@export var spot_light: SpotLight3D

func _ready():
	# Creation de la duplication du material car sinon ca change la couleur de tous les meshs ayant ce Material
	if get_active_material(0):
		var my_material = get_active_material(0).duplicate()
		set_surface_override_material(0, my_material)
	
	# On force un premier rafraîchissement une fois que le matériau unique est bien en place
	refresh()

# Permet à un autre script ou au signal d'un bouton de changer directement la couleur
func set_selection(index:int):
	# Assigner la valeur déclenche automatiquement le "set(value)" du haut,
	# qui lui-même appelle déjà refresh(). Pas besoin de l'écrire deux fois !
	led_color = index

# fonction qui permet de forcer une couleur spécifique directement (comme le noir)
# elle force maintenant aussi l'état de l'émission et du spot unique pour le clignotement
func set_forced_color(custom_color: Color):
	var my_material = get_surface_override_material(0)
	if my_material:
		# 1. On force la couleur Albedo de base
		my_material.albedo_color = custom_color
		
		# 2. Si l'émission est cochée, on doit l'éteindre si le clignoteur envoie du noir
		if use_emission:
			# La condition (custom_color != Color.BLACK) renvoie True si c'est allumé, False si c'est Noir
			my_material.emission_enabled = (custom_color != Color.BLACK)
			my_material.emission = custom_color
			
		# 3. On éteint ou on allume le spot physique en fonction de la couleur (OFF si Noir)
		_update_spot_light(custom_color, custom_color != Color.BLACK)
		
		color_changed.emit(custom_color)

func refresh():
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
			
		# Application de la couleur sur le material
		my_material.albedo_color = base_color
		
		# --- GESTION DE L'ÉMISSION ---
		if use_emission:
			my_material.emission_enabled = true
			my_material.emission = base_color
		else:
			my_material.emission_enabled = false
			
		# --- GESTION DU SPOT LIGHT ---
		# En mode normal (refresh), le spot est allumé (true) avec la couleur de base
		_update_spot_light(base_color, true)
		
		# j'envoie l'info au reste du monde
		color_changed.emit(base_color)

# fonction interne pour gérer proprement l'état du spot light
func _update_spot_light(light_color: Color, light_is_on: bool):
	if spot_light:
		spot_light.visible = light_is_on
		spot_light.light_color = light_color
