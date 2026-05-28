class_name EJModCodeEditLoadDefaultScript
extends Node

signal on_code_loaded_as_text(text: String)

@export var script_to_load: Script
@export var load_at_ready: bool = true
@export var text_editors_to_affect: Array[TextEdit]


func _ready() -> void:
	if load_at_ready:
		load_script_as_text()


func load_script_as_text() -> void:
	if script_to_load == null:
		push_error("No default script was provided.")
		return

	var code: String = script_to_load.source_code

	for text_editor in text_editors_to_affect:
		if text_editor:
			text_editor.text = code

	on_code_loaded_as_text.emit(code)
