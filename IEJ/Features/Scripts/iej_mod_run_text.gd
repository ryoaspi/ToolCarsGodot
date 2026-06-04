class_name IEJModRunText
extends Node

signal on_destroy_previous_node_start(node: Node)
signal on_destroy_previous_node_end()
signal on_created_node(node_created: Node)
signal on_created_node_with_code(node_created: Node, code: String)
signal on_fail_to_load_code(code: String)

@export_multiline()
var default_code_to_execute: String = """
extends Node

func _ready() -> void:
	print("Hello World")

func _process(delta: float) -> void:
	pass
"""

@export var where_to_create_node: Node
@export var run_code_at_ready: bool = false
@export var unique_code_file_name: String = "user_free_code.gd"

@export var method_name_to_send_car_info: String = "_on_car_received" 

@export_group("Debug")
@export var created_node_holding_code: Node
@export var last_car_received: Node
@export var last_code_received: String


func set_where_to_execute(node: Node):
	where_to_create_node = node
	
func set_target_car(node: Node):
	notify_car_received(node)
	
func set_target_car_and_reload(node: Node):
	load_and_run_text_as_godot_script(last_code_received)
	notify_car_received(node)


func notify_car_received(node: Node):
	last_car_received= node
	if created_node_holding_code: 
		if created_node_holding_code.has_method(method_name_to_send_car_info):
			created_node_holding_code.call(method_name_to_send_car_info, node)

func _ready() -> void:
	if run_code_at_ready:
		await get_tree().create_timer(0.1).timeout
		load_and_run_text_as_godot_script(default_code_to_execute)


func unload_current_code() -> void:
	on_destroy_previous_node_start.emit(created_node_holding_code)

	if created_node_holding_code:
		created_node_holding_code.queue_free()
		created_node_holding_code = null

	on_destroy_previous_node_end.emit()



func load_and_run_text_as_godot_script(code: String) -> void:
	if code.strip_edges() == "":
		push_error("The CodeEdit is empty.")
		on_fail_to_load_code.emit(code)
		return

	last_code_received = code
	unload_current_code()

	var final_code: String = code

	if not final_code.contains("extends "):
		final_code = "extends Node\n\n" + final_code

	var script_path: String = "user://" + unique_code_file_name

	print("Generated user script path:")
	print(ProjectSettings.globalize_path(script_path))

	var file_connection := FileAccess.open(script_path, FileAccess.WRITE)

	if file_connection:
		file_connection.store_string(final_code)
		file_connection.close()
	else:
		push_error("The user script file could not be created.")
		on_fail_to_load_code.emit(final_code)
		return

	var script: Script = ResourceLoader.load(
		script_path,
		"GDScript",
		ResourceLoader.CACHE_MODE_IGNORE
	)

	if not script is GDScript:
		push_error("The provided text is not a valid GDScript.")
		on_fail_to_load_code.emit(final_code)
		return

	var node := Node.new()

	node.set_script(script)
	node.set_process(true)
	node.set_physics_process(true)

	created_node_holding_code = node

	if where_to_create_node:
		where_to_create_node.add_child(node)
	else:
		add_child(node)

	print("User code is now running.")

	notify_car_received(last_car_received)
	on_created_node.emit(node)
	on_created_node_with_code.emit(node, final_code)


func _on_submit_codebutton_on_code_submit(text: String) -> void:
	pass # Replace with function body.
