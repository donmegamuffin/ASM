extends Control

func _ready() -> void:
	print(ASMInstructions.EInstruction.MAX)
	#var code: ASMCompiler.Program = ASMCompiler.compile(%CodeEdit.text)
	#print(type_string(typeof(code)))
	#for line in code.instructions:
	#	print(line)
	
	


func _on_code_edit_breakpoint_toggled(_line: int) -> void:
	var code: ASMCompiler.Program = ASMCompiler.compile(%CodeEdit.text)
	print(type_string(typeof(code)))
	for inst in code.instructions:
		print(inst)
	%cpu_node.load_program(code)
	print(%cpu_node.program.instructions)
	for i in range(10):
		%cpu_node.tick()
		print(%cpu_node.ip)
		print(%cpu_node.registers[1])
