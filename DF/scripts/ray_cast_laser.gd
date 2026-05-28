extends RayCast3D

@export var laser_enabled : bool = true:
	set(value):
		laser_enabled = value
		enabled = value
		$LaserRay.visible = value
		
func _ready() -> void:
	enabled = laser_enabled
	$LaserRay.visible = laser_enabled

func _physics_process(delta: float) -> void:
	if not laser_enabled:
		return
	if is_colliding():
		var hit = get_collider()
