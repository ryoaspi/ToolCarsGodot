class_name RGBFromRayCast

extends Node3D

@onready var raycast: RayCast3D = $MoveRaycast/RayCast3D
var last_object_hit : Node3D
var _image : Image
var pixel_position : Vector2i

signal on_rgba_from_raycast(rgba : Vector4i)

func _physics_process(delta: float) -> void:
	if raycast.is_colliding() :
		var collider = raycast.get_collider()
		var object :Node3D = collider.get_parent()
		if _result_change(object):
			_set_image_from_object(object)
		
		var mesh_size = object.mesh.size
		mesh_size = Vector3(mesh_size.x,0,mesh_size.y)
		var corner_position = object.global_position - mesh_size * 0.5
		var hit_position =  - corner_position - raycast.get_collision_point()
		var pixelX : int = remap(hit_position.x,0,mesh_size.x,0,1) * _image.get_width()
		var pixelY : int = remap(hit_position.z,0,mesh_size.z,0,1) * _image.get_height()
		pixel_position = Vector2i(pixelX,pixelY)
		
		var color_v4i : Vector4i = _get_RGBA_from_image(pixel_position)
		on_rgba_from_raycast.emit(color_v4i)

func _result_change(new_object: Node3D) -> bool:
	if not last_object_hit:
		last_object_hit = new_object
		return true
	if new_object != last_object_hit:
		last_object_hit = new_object
		return true
	return false
	

func _set_image_from_object(object : Node3D) -> void:
	var mesh_instance := object as MeshInstance3D
	
	var texture = mesh_instance.get_active_material(0).albedo_texture
	
	if texture:
		_image = texture.get_image()
		print ("la height "+ str(_image.get_height()))
		print("la width " + str(_image.get_width()))
		return
	print("texture c'est pas une texture")

func _get_RGBA_from_image(pixel : Vector2i) -> Vector4i:
	var color : Color = Color.from_rgba8(0,0,0,0)
	if _image:
		color = _image.get_pixelv(pixel)
	return Vector4i(remap(color.r,0,1,0,255),
	remap(color.g,0,1,0,255),
	remap(color.b,0,1,0,255),
	remap(color.a,0,1,0,255))

func get_RGBA_from_raycast() -> Vector4i:
	return _get_RGBA_from_image(pixel_position)

func set_image(image : Image) -> void:
	_image = image
