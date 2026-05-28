extends Node

@export var my_dict : DGScanDictionary


func open_scan_from_text(text:String):
	text = text.replace("\n","").replace("\r","") #Delete space and enter
	if my_dict.scan_to_text.has(text): #Check if there is text 
		var test := my_dict.scan_to_text[text] 
		print(test)
		
func open_url_from_text(text:String):
	text = text.replace("\n","").replace("\r","") #Delete space and enter
	if my_dict.scan_to_text.has(text):
		var test2 := my_dict.scan_to_text[text]
		var url := OS.shell_open(test2) # Open the URL 
		print(test2)
