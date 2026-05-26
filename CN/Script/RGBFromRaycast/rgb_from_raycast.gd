class_name RGBFromRayCast

extends Node3D

@onready var raycast: RayCast3D = $MoveRaycast/RayCast3D
var last_object_hit : Node3D
var _image : Image

@export var debug : Vector3i


func _physics_process(delta: float) -> void:
	if raycast.is_colliding() :
		var collider = raycast.get_collider()
		var object :Node3D = collider.get_parent()
		
		if _result_change(object):
			_set_image_from_object(object)
		var mesh_size = object.mesh.size
		mesh_size = Vector3(mesh_size.x,0,mesh_size.y)
		var corner_position = object.global_position - mesh_size * 0.5
		var hit_position = raycast.global_position - corner_position
		var pixelX : int = remap(hit_position.x,0,mesh_size.x,0,1) * 512
		var pixelY : int = remap(hit_position.z,0,mesh_size.z,0,1) * 512
		var pixel_position = Vector2i(pixelX,pixelY)
		debug = _get_RGB_from_image(pixel_position)
		print (debug)

func _result_change(new_object: Node3D) -> bool:
	if not last_object_hit:
		last_object_hit = new_object
		return true
	if new_object != last_object_hit:
		last_object_hit = new_object
		return true
	return false

func _get_RGB_from_image(pixel : Vector2i) -> Vector3i:
	var color : Color = Color.BLACK
	if _image:
		color = _image.get_pixelv(pixel)
	return Vector3i(remap(color.r,0,1,0,255),remap(color.g,0,1,0,255),remap(color.b,0,1,0,255))


func _set_image_from_object(object : Node3D) -> void:
	var texture: Texture2D = object.get_surface_override_material(0).albedo_texture
	if texture:
		_image = texture.get_image()
