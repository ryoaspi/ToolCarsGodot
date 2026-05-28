class_name IEJCarCodeRunner
extends Node

signal on_destroy_previous_node_start(node: Node)
signal on_destroy_previous_node_end()
signal on_created_node(node_created: Node)
signal on_created_node_with_code(node_created: Node, code: String)
signal on_fail_to_load_code(code: String)

@export var where_to_create_node: Node
@export var unique_code_file_name: String = "car_code.gd"

@export_group("Debug")
@export var created_node_holding_code: Node
@export var given_car: Node
@export var method_name_to_send_car: String = "_on_received_the_car"


func  set_given_car_node_with(node: Node):
	given_car = node
	if created_node_holding_code.has_method(method_name_to_send_car):
		created_node_holding_code.call(method_name_to_send_car, node)




func _on_screen_command_submitted(command_text: String) -> void:
	var generated_code := convert_command_text_to_godot_code(command_text)
	load_and_run_text_as_godot_script(generated_code)


func convert_command_text_to_godot_code(command_text: String) -> String:
	var commands := command_text.split(";")
	var code := ""

	code += "extends Node\n"
	code += "\n"
	code += "var car: ProgrammableCar\n"
	code += "\n"
	code += "func setup(p_car: ProgrammableCar) -> void:\n"
	code += "\tcar = p_car\n"
	code += "\n"
	code += "func _ready() -> void:\n"
	code += "\tif car == null:\n"
	code += "\t\tprint(\"No car connected\")\n"
	code += "\t\tqueue_free()\n"
	code += "\t\treturn\n"
	code += "\n"

	for command in commands:
		var clean_command := command.strip_edges().to_lower()

		if clean_command != "":
			code += "\tcar.execute_command(\"" + clean_command + "\")\n"

	code += "\tqueue_free()\n"

	return code


func unload_current_code() -> void:
	on_destroy_previous_node_start.emit(created_node_holding_code)

	if created_node_holding_code:
		created_node_holding_code.queue_free()
		created_node_holding_code = null

	on_destroy_previous_node_end.emit()


func load_and_run_text_as_godot_script(code: String) -> void:
	unload_current_code()

	var script_path: String = "user://" + unique_code_file_name

	print(ProjectSettings.globalize_path(script_path))

	var file_connection := FileAccess.open(script_path, FileAccess.WRITE)

	if file_connection:
		file_connection.store_string(code)
		file_connection.close()
	else:
		push_error("File was not created")
		on_fail_to_load_code.emit(code)
		return

	var script: Script = ResourceLoader.load(
		script_path,
		"GDScript",
		ResourceLoader.CACHE_MODE_IGNORE
	)

	if not script is GDScript:
		push_error("That is not a Godot Script")
		on_fail_to_load_code.emit(code)
		return

	var node := Node.new()

	node.set_script(script)


	created_node_holding_code = node

	if where_to_create_node:
		where_to_create_node.add_child(node)
	else:
		add_child(node)

	if node.has_method("setup"):
		node.call("setup")
		
	set_given_car_node_with(given_car)
	
	
	on_created_node.emit(node)
	on_created_node_with_code.emit(node, code)
