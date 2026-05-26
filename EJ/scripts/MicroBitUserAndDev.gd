class_name MicroBitUSerAndDev
extends Node

signal on_push_dev(developer_code: String)
signal on_push_user(user_code: String)
signal on_push_dev_user(developer_code: String, user_code: String)
signal on_pushed() 

@export var developer_code: CodeEdit
@export var user_code : CodeEdit
@export var push_at_ready:bool = true

func _ready() -> void:
	if push_at_ready:
		push_code_in_code_edit()
		


func push_code_in_code_edit():
	on_push_dev.emit(developer_code.text)
	on_push_user.emit(user_code.text)
	on_push_dev_user.emit(developer_code.text,user_code.text)
	on_pushed.emit()
