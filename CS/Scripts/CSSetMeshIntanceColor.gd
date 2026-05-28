@tool
class_name CSSetMeshInstanceColor
extends Node

## Je glisse ici le ou les modèle(s) 3D (MeshInstance3D) dont je veux changer la couleur.
@export var meshes: Array[MeshInstance3D]

func _ready():
	# Je parcours chaque modèle 3D de ma liste au démarrage.
	for mesh_instance in meshes:
		# Je vérifie que le modèle existe et qu'il possède bien un matériau de base.
		if mesh_instance and mesh_instance.get_active_material(0):
			# Je crée une copie totalement indépendante de ce matériau.
			var unique_material = mesh_instance.get_active_material(0).duplicate()
			# J'applique cette copie sur mon modèle. Comme ça, si je change sa couleur, je ne changerai pas la couleur des autres voitures du jeu.
			mesh_instance.set_surface_override_material(0, unique_material)

func set_color(color: Color) -> void:
	# Cette fonction est appelée automatiquement quand elle reçoit le signal 'color_changed'.
	
	# Je passe en revue chaque modèle 3D de mon tableau.
	for mesh_instance in meshes:
		# Si la case est vide, je passe au suivant sans bloquer le jeu.
		if mesh_instance == null:
			continue

		# Je récupère le matériau unique que j'ai préparé dans ma fonction _ready.
		var my_material = mesh_instance.get_surface_override_material(0)
		
		# Je vérifie que ce matériau est bien un matériau standard (StandardMaterial3D).
		if my_material is StandardMaterial3D:
			# J'applique la couleur reçue sur la couleur de base (albedo) de mon matériau.
			my_material.albedo_color = color
