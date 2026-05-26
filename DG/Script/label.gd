extends Label


var echo:bool
var unicode: int

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed or event.scancode
			print(event.as_text_keycode())

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event is InputEventKey:
		var keycode = DisplayServer.keyboard_get_keycode_from_physical(event.physical_keycode)
		var label = DisplayServer.keyboard_get_label_from_physical(event.physical_keycode)
		print(OS.get_keycode_string(keycode))
		print(OS.get_keycode_string(label))
