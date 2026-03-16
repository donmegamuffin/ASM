extends Control

func _ready() -> void:
	print(ASMInstructions.EInstruction.MAX)
	var code: ASMCompiler.Program = ASMCompiler.jit(%CodeEdit.text)
	print(type_string(typeof(code)))
	for line in code.instructions:
		print(line)
	
