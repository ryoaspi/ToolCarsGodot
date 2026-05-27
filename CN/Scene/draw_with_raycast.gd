class_name DrawWithRayCast

extends Node3D

@onready var raycast: RayCast3D = $Move/RayCast3D

var cross = [
		Vector2i(0, 0),
		Vector2i(-1, 0),
		Vector2i(1, 0),
		Vector2i(0, 1),
		Vector2i(0, -1),
		]
		
var diamond = [
	Vector2i(0, -3),

	Vector2i(-1, -2),
	Vector2i(0, -2),
	Vector2i(1, -2),

	Vector2i(-2, -1),
	Vector2i(-1, -1),
	Vector2i(0, -1),
	Vector2i(1, -1),
	Vector2i(2, -1),

	Vector2i(-3, 0),
	Vector2i(-2, 0),
	Vector2i(-1, 0),
	Vector2i(0, 0),
	Vector2i(1, 0),
	Vector2i(2, 0),
	Vector2i(3, 0),

	Vector2i(-2, 1),
	Vector2i(-1, 1),
	Vector2i(0, 1),
	Vector2i(1, 1),
	Vector2i(2, 1),

	Vector2i(-1, 2),
	Vector2i(0, 2),
	Vector2i(1, 2),

	Vector2i(0, 3),
]

func _send_raycast_to_get_pixel_and_draw(color:Color) -> void:
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		var object :Node3D = collider.get_parent()
		
		var mesh_size = object.mesh.size
		mesh_size = Vector3(mesh_size.x,0,mesh_size.y)
		
		var corner_position = object.global_position - mesh_size * 0.5
		var hit_position = abs(corner_position - raycast.get_collision_point())
		var pixelX : int = remap(hit_position.x,0,mesh_size.x,0,1) * 128
		var pixelY : int = remap(hit_position.z,0,mesh_size.z,0,1) * 128
		var pixel_position = Vector2i(pixelX,pixelY)
		var mesh_instance := object as MeshInstance3D
		var material = mesh_instance.get_active_material(0)
		if material == null:
			print("material is null")
			return
			
		material = material.duplicate()
		mesh_instance.set_surface_override_material(0,material)
		var texture = material.albedo_texture
		if texture is not Texture2D:
			print("texture is not texture2D")
			return
		var image : Image = texture.get_image()
		var new_texture := ImageTexture.create_from_image(image)		
		
		for offset in diamond:
			var p :Vector2i = pixel_position + offset
			if p.x >= 0 and p.x < 128 and p.y >= 0 and p.y < 128:
				image.set_pixelv(p, color)
				new_texture.update(image)

		material.albedo_texture = new_texture
		return
	print("no collision")
