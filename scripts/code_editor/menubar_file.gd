extends PopupMenu

enum STATE{IDLE,OPENING,SAVING}

var fpath: String 
var code_edit: CodeEdit
var state = STATE.IDLE

signal file_content_read(text: String)

func _on_index_pressed(index: int) -> void:
	match index:
		0: new_file()
		1: open_file()
		@warning_ignore("standalone_ternary")
		2: save_as() if fpath else save_as() 
		3: save_as()

func new_file() -> void:
	return

func open_file() -> void:
	state = STATE.OPENING
	var file_dialog := instantiate_filedialog(FileDialog.FileMode.FILE_MODE_OPEN_FILE)
	get_tree().root.add_child(file_dialog)
	file_dialog.visible = true
	
func save() -> void:
	state = STATE.SAVING
	_save_file_deferred()

func save_as() -> void:
	state = STATE.SAVING
	var file_dialog := instantiate_filedialog(FileDialog.FileMode.FILE_MODE_SAVE_FILE)
	get_tree().root.add_child(file_dialog)
	file_dialog.visible = true

func instantiate_filedialog(file_mode: FileDialog.FileMode) -> FileDialog:
	var file_dialog := FileDialog.new()
	file_dialog.use_native_dialog = false
	file_dialog.force_native = false
	file_dialog.file_mode = file_mode
	file_dialog.files_selected.connect(_on_file_selected)
	return file_dialog
	
func _on_file_selected(path: String)->void:
	fpath = path
	match state:
		STATE.IDLE: return
		STATE.OPENING: _open_file_deferred()
		STATE.SAVING: _save_file_deferred()

func _open_file_deferred() -> void:
	var file = FileAccess.open(fpath,FileAccess.READ)
	code_edit.text = file.get_as_text()
	state = STATE.IDLE
	
func _save_file_deferred() -> void:
	var file = FileAccess.open(fpath,FileAccess.WRITE)
	file.store_string(code_edit.text)
	state = STATE.IDLE
