extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func open_url_from_text(text:String):
	text = text.replace("\n","").replace("\r","")
	if "éé((!&&§" == text:
		print("YEAAH")
	elif "ééé&&è!à" == text:
		print("NO WAY")
