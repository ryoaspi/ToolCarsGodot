class_name DGOpenUrl

extends Node

signal find_an_url(url: String)
signal find_a_not_url_text(text : String)
signal find_a_valid_text(text : String)
signal fail_to_load_a_key(fail_key : String)

@export var my_dict : DGScanDictionary
@export var open_url_when_found : bool = true	
	
	
func emit_value_of_the_given_key(text : String)-> bool:
	text = text.replace("\n","").replace("\r","")
	var value_of_the_key = ""
	if my_dict.scan_to_text.has(text): #Check if there is text 
		value_of_the_key = my_dict.scan_to_text[text] # Add and sent the text
		
	if value_of_the_key== "":
		fail_to_load_a_key.emit(text)
		return false	
		
	var is_a_url : bool = false
	if value_of_the_key.contains("https://") : 
		is_a_url = true
	elif value_of_the_key.contains("http://") : 
		is_a_url = true
		
	if is_a_url : 
		find_an_url.emit(value_of_the_key)
		if open_url_when_found : 
			open_url_from_text(value_of_the_key)
	else :
		find_a_not_url_text.emit(value_of_the_key)

	find_a_valid_text.emit(value_of_the_key)
	return true

func open_url_from_text(text:String): # Fonction who open an URL after a scan
	var url := OS.shell_open(text) # Open the URL 
	
		
