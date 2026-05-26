@tool
extends Node
signal on_typing_text (text : String)
signal new_text (text : String)
var echo:bool
var unicode: int
@export var wait_time:float = 1.5
@export var text_scan:String
var time_count:float

func _process(delta: float) -> void:
	if time_count > 0.0 :
		time_count -= delta
		if time_count < 0:
			new_text.emit(text_scan)
			text_scan = ""

func _input(event):
	if event is InputEventKey and event.pressed:
		var unicode_key_int :int =event.unicode
		if unicode_key_int!=0:
			time_count = wait_time
			var unicode = char(event.unicode)
			text_scan += unicode
			on_typing_text.emit(text_scan)
