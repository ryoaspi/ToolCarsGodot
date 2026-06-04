class_name IEJModCodeEditAndSubmitButton
extends Node

signal on_code_submit(text: String)

@export var code_editor: CodeEdit
@export var submit_button: Button


func _ready() -> void:
	if submit_button == null:
		push_error("No button connected in EJModCodeEditAndSubmitButton.")
		return

	if code_editor == null:
		push_error("No CodeEdit connected in EJModCodeEditAndSubmitButton.")
		return

	submit_button.pressed.connect(_on_submit_button_pressed)


func _on_submit_button_pressed() -> void:
	var code: String = code_editor.text
	on_code_submit.emit(code)


func _on_button_pressed() -> void:
	pass # Replace with function body.
