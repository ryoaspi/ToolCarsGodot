extends Node3D
class_name ScreenCoding

signal command_submitted(command: String)

@export var display_label: Label3D

var current_command: String = ""

func _ready() -> void:
	if display_label == null:
		push_error("Display Label is missing. Drag your Label3D into the exported variable.")
		return

	display_label.text = "> ready"

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER:
			submit_command()
			return

		if event.keycode == KEY_BACKSPACE:
			if current_command.length() > 0:
				current_command = current_command.substr(0, current_command.length() - 1)
			update_display()
			return

		if event.unicode > 0:
			current_command += char(event.unicode)
			update_display()

func update_display() -> void:
	if display_label == null:
		return

	display_label.text = "> " + current_command

func submit_command() -> void:
	var command := current_command.strip_edges().to_lower()

	if display_label != null:
		display_label.text = "> " + command

	command_submitted.emit(command)
	current_command = ""
