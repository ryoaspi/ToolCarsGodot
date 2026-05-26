@tool
class_name CSLEDColorSelection

extends MeshInstance3D

# Création du signal pour prévenir du changement de couleur
signal color_changed(newColor : Color)

# 0 = rouge, 1 = orange, 2 = vert (à entrer dans l'inspecteur)
@export var led_color: int
# Liste de couleurs personnalisables depuis l'inspecteur de Godot
@export var color_selection: Array[Color]
# couleur par défault si un chiffre différent de 0 , 1 et 2 est entré dans l'inspecteur
@export var default_color: Color = Color(1.0, 0.0, 1.0, 1.0)

func _ready():
	# Creation de la duplication du material car sinon ca change la couleur de tous les meshs ayant ce Material
	if get_active_material(0):
		var my_material = get_active_material(0).duplicate()
		set_surface_override_material(0, my_material)

# Fonction qui permet à un autre script (comme un bouton) de changer la couleur de la LED en connectant un signal
func set_selection(index:int):
	led_color = index

func _process(delta):
	# Je récupère le matériau unique configuré dans le _ready
	var my_material = get_surface_override_material(0)
	
	# Si le matériau existe bien, je gère la couleur
	if my_material:
		var base_color = default_color
		
		# Je regarde le chiffre écrit dans l'inspecteur pour trouver la bonne couleur dans la liste (Array)
		if led_color == 0:
			base_color = color_selection[0]
		elif led_color == 1:
			base_color = color_selection[1]
		elif led_color == 2:
			base_color = color_selection[2]
			
		# Application de la couleur
		my_material.albedo_color = base_color
		
		# émission du changement de couleur pour que les autres objets connacté au signal puissent réagir
		color_changed.emit(base_color)
