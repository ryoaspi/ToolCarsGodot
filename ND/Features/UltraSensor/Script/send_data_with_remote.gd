class_name  DnSendDataWithRemote

extends Node

signal send_integer_with_remote(id_input: int)
signal send_data_class_with_remote(info_data: Data)

var is_remote_grabbed: bool = false
var remote = Node3D

@export_group("Params")
## the size of button_string has to be the same as the button_value the first element of the button_string id gonna be linked with the first element of the button_value
@export var button_string: Array[String] = ["right action","top action"]
## the size of button_string has to be the same as the button_value the first element of the button_string id gonna be linked with the first element of the button_value
@export var button_value: Array[int] = [45,46]

func _input(event: InputEvent) -> void:
	if !is_remote_grabbed:
		return
	_check_input(event)

func _check_input(event: InputEvent) -> void:
	var event_stringyfied: String = event.as_text().to_lower()
	for i in button_string.size():
		if(event_stringyfied.contains(button_string[i].to_lower()) && event.is_pressed()):
			var data_right_action = Data.new(button_value[i],event.as_text())
			send_integer_with_remote.emit(button_value[i])
			send_data_class_with_remote.emit(data_right_action)
			print(event_stringyfied)
			print(button_value[i])

func _on_grab_point_hand_right_action_pressed(pickable: Variant, grab_point: Variant) -> void:
	if remote == pickable:
		is_remote_grabbed = true


func _on_grab_point_hand_right_action_released(pickable: Variant, grab_point: Variant) -> void:
	if remote == pickable:
		is_remote_grabbed = false
