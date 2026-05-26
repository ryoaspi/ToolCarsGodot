class_name MicroBitDevpUserToNode
extends Node


@export var developer_code: String
@export var code_between_to_split = "\n\n###--------- DEV|USER---------###\n\n"
@export var user_code: String



func set_developer_code(code: String):
	developer_code = code
func set_user_code(code: String):
	user_code = code
func set_developer_and_user_code(code_dev: String,code_user: String):
	set_developer_code(code_dev)
	set_user_code(code_user)


func print_crurent_code_loaded():
	print(developer_code,code_between_to_split, user_code)

func try_execute_code():
	var code_t_execute: String
