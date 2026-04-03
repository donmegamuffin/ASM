extends CodeHighlighter
	
# Theme colours
const colour_palette : Dictionary = {
	"comment" : Color.AQUAMARINE,
	"label": Color.PAPAYA_WHIP,
	"instruction": Color.STEEL_BLUE,
	"register": Color.OLIVE_DRAB,
	"value": Color.INDIAN_RED,
	"memory_address": Color.PALE_VIOLET_RED,
	"unknown": Color.CRIMSON
}
	
func _get_line_syntax_highlighting(line: int) -> Dictionary:
	# Returns syntax highlighting on a column-based (per char) level.
	# Annoyingly, this isn't reflected in-editor... but we'll fix that 
	# some other time.
	
	# There are essentially 4 types on lines:
	# 1) Blank [No need to do anything]
	# 2) Comments - Starting with #, can just colour all comment colour
	# 3) Labels - Colour whole line one colour, but check if has a comment after
	# 4) Instruction - Trickiest, have to split up and check each part for
	#		Instruction? Register? Value? Memoryaddr? Comment? 	
	var text: String = get_text_edit().get_line(line).lstrip(" \t")
	# 1) Blank
	if len(text.strip_escapes().lstrip(" ").rstrip(" ")) == 0:
		return {}
	# 2) Comment line
	if text.lstrip(" \t")[0] == "#":
		return {0: {"color": colour_palette.comment}}
	# 3) Label Line
	if text.split(" ",false)[0][-1] == ":":
		if "#" in text:
			# Just keep iterating over it until we hit a comment
			var start_of_comment: int = 0
			for i in range(len(text)):
				if text[i] == "#":
					start_of_comment = i
			return {0: 
				{"color": colour_palette.label}, 
			start_of_comment:
				{"color": colour_palette.comment}}
		return {0: {"color": colour_palette.label}}
	# 4) Instruction line
	if len(text.split(" ",false)[0]) == 3:
		return _parse_instruction_line(text)
	# Case 5) Fallback
	return {0: {"color":colour_palette.unknown}}
	
func _parse_instruction_line(line:String) -> Dictionary:
	var symbols = {}
	var i: int = 0
	var n: int = len(line)
	
	var isspace := func (s:String)->bool: return len(s.strip_edges()) == 0
	symbols[0] = {"color":colour_palette.instruction}
	while i < n:
		# Skip whitespace
		if isspace.call(line[i]):
			i += 1
			continue
		var start_index: int = i
		# Handle Comments
		if line[i] == '#':
			symbols[i] = {'color': colour_palette.comment}
			break # Comments consume the rest of the line
		# Find end of the current token (next whitespace or start of comment)
		while i < n :
			if isspace.call(line[i]):
				break
			i += 1
		var token: String = line.substr(start_index,i-start_index)
		assert(not (" " in token))
		# Categorize the token using our Enums
		# All uppercase and not a number is an Instruction
		if token == token.to_upper() and (not token.is_valid_int()) and len(token)!=3:
			symbols[start_index] = {"color":colour_palette.label}
		elif token[0] == "r": # Register
			symbols[start_index] = {"color":colour_palette.register}
		elif token.is_valid_int():
			symbols[start_index] = {"color":colour_palette.value}
		elif token == token.to_upper() and (not token.is_valid_int()) and len(token)==3:
			symbols[start_index] = {"color":colour_palette.instruction}
		else:
			symbols[start_index] = {"color":colour_palette.unknown}
	return symbols
