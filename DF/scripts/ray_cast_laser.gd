extends RayCast3D

@export var laser_enabled : bool = false :
	set(value):
		laser_enabled = value
		enabled = value
		$MeshInstance3D.visible = value

func _ready() -> void:
	enabled = laser_enabled
	$MeshInstance3D.visible = laser_enabled

func _physics_process(delta: float) -> void:
	if not laser_enabled:
		return
	
	if is_colliding():
		var hit = get_collider()
		print(hit.name)
