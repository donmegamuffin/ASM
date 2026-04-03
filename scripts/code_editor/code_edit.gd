extends CodeEdit

func _ready() -> void:
	set_code_completion_prefixes(["S"])
	add_code_completion_option(CodeEdit.KIND_VARIABLE,"Sugmaballs","lmao_Gottem")
	update_code_completion_options(true)
	request_code_completion(true)

	


func _on_text_changed() -> void:
	request_code_completion(true)
	get_code_completion_options()


func _on_file_menu_file_content_read(text: String) -> void:
	self.text = text
