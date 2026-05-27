class_name CSSetMeshInstanceColor
extends Node

@export var meshes: Array[MeshInstance3D]

func _ready():
	# Sécurité indispensable pour le modding : on rend les matériaux uniques
	# au démarrage pour ne pas repeindre toutes les voitures du jeu d'un coup !
	for mesh_instance in meshes:
		if mesh_instance and mesh_instance.get_active_material(0):
			var unique_material = mesh_instance.get_active_material(0).duplicate()
			mesh_instance.set_surface_override_material(0, unique_material)

# Cette fonction va recevoir la couleur émise par le signal de CSLEDColorSelection
func set_color(color: Color) -> void:
	for mesh_instance in meshes:
		if mesh_instance == null:
			continue

		var my_material = mesh_instance.get_surface_override_material(0)
		if my_material is StandardMaterial3D:
			my_material.albedo_color = color
			
			# Gestion de l'émission (on l'éteint si la couleur reçue est noire)
			if color == Color.BLACK:
				my_material.emission_enabled = false
			else:
				my_material.emission_enabled = true
				my_material.emission = color
