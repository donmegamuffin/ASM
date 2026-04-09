extends Tree

const ASM_scripts_path: String = "user://ASM_scripts/"
signal fpath_selected_for_opening(fpath:String)


func _ready():
	# Setup the tree to look like a file explorer
	hide_root = true
	clear()
	var root = create_item()
	# Start scanning from the project root
	print(OS.get_user_data_dir())
	DirAccess.make_dir_absolute(ASM_scripts_path)
	build_file_tree(ASM_scripts_path, root)

func build_file_tree(path: String, parent_item: TreeItem):
	var dir = DirAccess.open(path) # [2]
	if dir == null:
		print("Failed to open path: ", path)
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if file_name == "." or file_name == "..":
			file_name = dir.get_next()
			continue
		
		# Create an item in the Tree [3]
		var item = create_item(parent_item)
		item.set_text(0, file_name)
		
		var full_path = path + "/" +file_name
		
		# If it's a directory, recurse into it
		if dir.current_is_dir():
			build_file_tree(full_path, item)
		
		file_name = dir.get_next()

# Connect this to the Tree's 'item_selected' signal
func _on_item_selected():
	var selected_item: TreeItem = get_selected()
	# You can store the file path in the item's metadata
	# or reconstruct it based on the tree hierarchy.
	if selected_item and (selected_item.get_child_count()==0):
		var path := get_item_full_path(selected_item)
		fpath_selected_for_opening.emit(path)

func get_item_full_path(item: TreeItem) -> String:
	var path_parts = []
	var current_item = item

	# Climb the tree until we reach the root (where get_parent() is null)
	while current_item != null:
		# Get the text of the current item (assuming the path is in column 0)
		var item_text = current_item.get_text(0)

		# We avoid adding empty strings if the root is hidden or empty
		if item_text != "":
			path_parts.append(item_text)

		current_item = current_item.get_parent()

	# Because we climbed UP, the array is [file, folder, root]
	# We need to reverse it to get [root, folder, file]
	path_parts.reverse()

	# Join the parts with a forward slash
	var full_path = "/".join(path_parts)

	# Ensure it starts with a slash if you are using absolute paths (like res://)
	if not full_path.begins_with("/"):
		# This part depends on if your root item text is "res:" or "/"
		# If your root is "res:", you might want to ensure it looks like "res://"
		full_path = full_path.replace("user:", "user://")

	return ASM_scripts_path+"/"+full_path
