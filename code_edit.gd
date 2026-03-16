extends CodeEdit

#class ASMHighlighter extends CodeHighlighter:
	#
	## Theme colours
	#const colour_palette : Dictionary = {
		#"Aqua":Color.AQUA,
		#"Blue":Color.BLUE,
		#"Chartreuse":Color.CHARTREUSE,
		#"Crimson":Color.CRIMSON,
		#"Cadet_blue":Color.CADET_BLUE,
	#}
		#
	#func _get_line_syntax_highlighting(line: int) -> Dictionary:
		## Returns syntax highlighting on a column-based level.
		#update_cache()
		#
		#return {0: {"color":Color.MAGENTA}}

func _ready():
	#var compl := ASMHighlighter.new()
	#syntax_highlighter = compl
	pass
