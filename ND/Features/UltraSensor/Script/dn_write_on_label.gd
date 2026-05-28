extends Label


func set_text_meter(text: float) -> void:
	var stringify_text: String = str(text)
	self.text = stringify_text
