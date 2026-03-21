extends Node

var program: ASMCompiler.Program = null
var ip: int = 0			# Instruction pointer
var memory: Array = []
var registers: Array = []
var running: bool = false

func _init(memory_size:int=128, n_registers:int=16) -> void:
	memory.resize(memory_size)
	registers.resize(n_registers)
	return
	
func load_program(tprogram: ASMCompiler.Program):
	program = tprogram

func tick():
	if not running or ip >= len(program.instructions):
		running = false
		return
	var instruction_line: Array[int] = program.instructions[ip]
	ip += 1
	execute(instruction_line)
	
func execute(instruction_line: Array[int]):
	# Acts as the instruction router
	match instruction_line[0]:
		ASMInstructions.EInstruction.ADD: _op_ADD(instruction_line)
		ASMInstructions.EInstruction.ADDri: _op_ADDri(instruction_line)
		ASMInstructions.EInstruction.ADDir: _op_ADDir(instruction_line)
		ASMInstructions.EInstruction.SUB: _op_SUB(instruction_line)
		ASMInstructions.EInstruction.SUBri: _op_SUBri(instruction_line)
		ASMInstructions.EInstruction.SUBir: _op_SUBir(instruction_line)
		ASMInstructions.EInstruction.MUL: _op_MUL(instruction_line)
		ASMInstructions.EInstruction.MULri: _op_MULri(instruction_line)
		ASMInstructions.EInstruction.MULir: _op_MULir(instruction_line)
		ASMInstructions.EInstruction.DIV: _op_DIV(instruction_line)
		ASMInstructions.EInstruction.DIVri: _op_DIVri(instruction_line)
		ASMInstructions.EInstruction.DIVir: _op_DIVir(instruction_line)
		ASMInstructions.EInstruction.MOD: _op_MOD(instruction_line)
		ASMInstructions.EInstruction.MODri: _op_MODri(instruction_line)
		ASMInstructions.EInstruction.MODir: _op_MODir(instruction_line)
		ASMInstructions.EInstruction.MIN: _op_MIN(instruction_line)
		ASMInstructions.EInstruction.MINri: _op_MINri(instruction_line)
		ASMInstructions.EInstruction.MINir: _op_MINir(instruction_line)
		ASMInstructions.EInstruction.MAX: _op_MAX(instruction_line)
		ASMInstructions.EInstruction.MAXri: _op_MAXri(instruction_line)
		ASMInstructions.EInstruction.MAXir: _op_MAXir(instruction_line)
		ASMInstructions.EInstruction.NEG: _op_NEG(instruction_line)
		ASMInstructions.EInstruction.AND: _op_AND(instruction_line)
		ASMInstructions.EInstruction.ANDri: _op_ANDri(instruction_line)
		ASMInstructions.EInstruction.ANDir: _op_ANDir(instruction_line)
		ASMInstructions.EInstruction.ORR: _op_ORR(instruction_line)
		ASMInstructions.EInstruction.ORRri: _op_ORRri(instruction_line)
		ASMInstructions.EInstruction.ORRir: _op_ORRir(instruction_line)
		ASMInstructions.EInstruction.NOT: _op_NOT(instruction_line)
		ASMInstructions.EInstruction.NOTri: _op_NOTri(instruction_line)
		ASMInstructions.EInstruction.NOTir: _op_NOTir(instruction_line)
		ASMInstructions.EInstruction.XOR: _op_XOR(instruction_line)
		ASMInstructions.EInstruction.XORri: _op_XORri(instruction_line)
		ASMInstructions.EInstruction.XORir: _op_XORir(instruction_line)
		ASMInstructions.EInstruction.JMP: _op_JMP(instruction_line)
		ASMInstructions.EInstruction.JGT: _op_JGT(instruction_line)
		ASMInstructions.EInstruction.JLT: _op_JLT(instruction_line)
		ASMInstructions.EInstruction.JEQ: _op_JEQ(instruction_line)
		ASMInstructions.EInstruction.JNE: _op_JNE(instruction_line)
		ASMInstructions.EInstruction.JGE: _op_JGE(instruction_line)
		ASMInstructions.EInstruction.JLE: _op_JLE(instruction_line)
		ASMInstructions.EInstruction.JAL: _op_JAL(instruction_line)
		ASMInstructions.EInstruction.STR: _op_STR(instruction_line)
		ASMInstructions.EInstruction.LDR: _op_LDR(instruction_line)
		ASMInstructions.EInstruction.MOV: _op_MOV(instruction_line)
		ASMInstructions.EInstruction.END: _op_END(instruction_line)
		ASMInstructions.EInstruction.LBL: _op_LBL(instruction_line)
		ASMInstructions.EInstruction.NOP: _op_NOP(instruction_line)
		_: assert(1==2)
	return

func _op_ADD(instruction_line):
	pass
	
func _op_ADDri(instruction_line):
	pass
	
func _op_ADDir(instruction_line):
	pass
	
func _op_SUB(instruction_line):
	pass
	
func _op_SUBri(instruction_line):
	pass
	
func _op_SUBir(instruction_line):
	pass
	
func _op_MUL(instruction_line):
	pass
	
func _op_MULri(instruction_line):
	pass
	
func _op_MULir(instruction_line):
	pass
	
func _op_DIV(instruction_line):
	pass
	
func _op_DIVri(instruction_line):
	pass
	
func _op_DIVir(instruction_line):
	pass
	
func _op_MOD(instruction_line):
	pass
	
func _op_MODri(instruction_line):
	pass
	
func _op_MODir(instruction_line):
	pass
	
func _op_MIN(instruction_line):
	pass
	
func _op_MINri(instruction_line):
	pass
	
func _op_MINir(instruction_line):
	pass
	
func _op_MAX(instruction_line):
	pass
	
func _op_MAXri(instruction_line):
	pass
	
func _op_MAXir(instruction_line):
	pass
	
func _op_NEG(instruction_line):
	pass
	
func _op_AND(instruction_line):
	pass
	
func _op_ANDri(instruction_line):
	pass
	
func _op_ANDir(instruction_line):
	pass
	
func _op_ORR(instruction_line):
	pass
	
func _op_ORRri(instruction_line):
	pass
	
func _op_ORRir(instruction_line):
	pass
	
func _op_NOT(instruction_line):
	pass
	
func _op_NOTri(instruction_line):
	pass
	
func _op_NOTir(instruction_line):
	pass
	
func _op_XOR(instruction_line):
	pass
	
func _op_XORri(instruction_line):
	pass
	
func _op_XORir(instruction_line):
	pass
	
func _op_JMP(instruction_line):
	pass
	
func _op_JGT(instruction_line):
	pass
	
func _op_JLT(instruction_line):
	pass
	
func _op_JEQ(instruction_line):
	pass
	
func _op_JNE(instruction_line):
	pass
	
func _op_JGE(instruction_line):
	pass
	
func _op_JLE(instruction_line):
	pass
	
func _op_JAL(instruction_line):
	pass
	
func _op_STR(instruction_line):
	pass
	
func _op_LDR(instruction_line):
	pass
	
func _op_MOV(instruction_line):
	pass
	
func _op_END(instruction_line):
	pass
	
func _op_LBL(instruction_line):
	pass
	
func _op_NOP(instruction_line):
	pass
	
