class_name CPUComponent extends Node

var program: ASMCompiler.Program = null
var ip: int = 0 # Instruction pointer
var memory: MemoryComponent = null
var registers: Array = []
var running: bool = false

func _init(n_registers:int=16) -> void:
	registers.resize(n_registers)
	reset_state()
	
func bind_to_memory(memory_comp: MemoryComponent):
	memory = memory_comp
	
func reset_state():
	ip = 0
	registers.fill(0.)
	
func load_program(tprogram: ASMCompiler.Program):
	program = tprogram
	running = true

func tick():
	if not running or ip >= len(program.instructions):
		running = false
		return
	var inst: Array[int] = program.instructions[ip]
	ip += 1
	execute(inst)
	
func execute(inst: Array[int]):
	# Acts as the instruction router. An instruction is
	# Operation, [Operand...,]
	match inst[0]:
		ASMInstructions.EInstruction.ADD: _op_ADD(inst)
		ASMInstructions.EInstruction.ADDri: _op_ADDri(inst)
		ASMInstructions.EInstruction.ADDir: _op_ADDir(inst)
		ASMInstructions.EInstruction.SUB: _op_SUB(inst)
		ASMInstructions.EInstruction.SUBri: _op_SUBri(inst)
		ASMInstructions.EInstruction.SUBir: _op_SUBir(inst)
		ASMInstructions.EInstruction.MUL: _op_MUL(inst)
		ASMInstructions.EInstruction.MULri: _op_MULri(inst)
		ASMInstructions.EInstruction.MULir: _op_MULir(inst)
		ASMInstructions.EInstruction.DIV: _op_DIV(inst)
		ASMInstructions.EInstruction.DIVri: _op_DIVri(inst)
		ASMInstructions.EInstruction.DIVir: _op_DIVir(inst)
		ASMInstructions.EInstruction.MOD: _op_MOD(inst)
		ASMInstructions.EInstruction.MODri: _op_MODri(inst)
		ASMInstructions.EInstruction.MODir: _op_MODir(inst)
		ASMInstructions.EInstruction.MIN: _op_MIN(inst)
		ASMInstructions.EInstruction.MINri: _op_MINri(inst)
		ASMInstructions.EInstruction.MINir: _op_MINir(inst)
		ASMInstructions.EInstruction.MAX: _op_MAX(inst)
		ASMInstructions.EInstruction.MAXri: _op_MAXri(inst)
		ASMInstructions.EInstruction.MAXir: _op_MAXir(inst)
		ASMInstructions.EInstruction.NEG: _op_NEG(inst)
		ASMInstructions.EInstruction.AND: _op_AND(inst)
		ASMInstructions.EInstruction.ANDri: _op_ANDri(inst)
		ASMInstructions.EInstruction.ANDir: _op_ANDir(inst)
		ASMInstructions.EInstruction.ORR: _op_ORR(inst)
		ASMInstructions.EInstruction.ORRri: _op_ORRri(inst)
		ASMInstructions.EInstruction.ORRir: _op_ORRir(inst)
		ASMInstructions.EInstruction.NOT: _op_NOT(inst)
		ASMInstructions.EInstruction.XOR: _op_XOR(inst)
		ASMInstructions.EInstruction.XORri: _op_XORri(inst)
		ASMInstructions.EInstruction.XORir: _op_XORir(inst)
		ASMInstructions.EInstruction.JMP: _op_JMP(inst)
		ASMInstructions.EInstruction.JGT: _op_JGT(inst)
		ASMInstructions.EInstruction.JLT: _op_JLT(inst)
		ASMInstructions.EInstruction.JEQ: _op_JEQ(inst)
		ASMInstructions.EInstruction.JNE: _op_JNE(inst)
		ASMInstructions.EInstruction.JGE: _op_JGE(inst)
		ASMInstructions.EInstruction.JLE: _op_JLE(inst)
		ASMInstructions.EInstruction.JAL: _op_JAL(inst)
		ASMInstructions.EInstruction.STR: _op_STR(inst)
		ASMInstructions.EInstruction.LDR: _op_LDR(inst)
		ASMInstructions.EInstruction.MOV: _op_MOV(inst)
		ASMInstructions.EInstruction.END: _op_END(inst)
		ASMInstructions.EInstruction.LBL: _op_LBL(inst)
		ASMInstructions.EInstruction.NOP: _op_NOP(inst)
		_: push_error("Unknown instruction.")
	return

func _op_ADD(inst):
	registers[inst[1]] = registers[inst[2]] + registers[inst[3]]
	
func _op_ADDri(inst):
	registers[inst[1]] = registers[inst[2]] + inst[3]
	
func _op_ADDir(inst):
	registers[inst[1]] = inst[2] + registers[inst[3]]
	
func _op_SUB(inst):
	registers[inst[1]] = registers[inst[2]] - registers[inst[3]]

func _op_SUBri(inst):
	registers[inst[1]] = registers[inst[2]] - inst[3]

func _op_SUBir(inst):
	registers[inst[1]] = inst[2] - registers[inst[3]]

func _op_MUL(inst):
	registers[inst[1]] = registers[inst[2]] * registers[inst[3]]
	
func _op_MULri(inst):
	registers[inst[1]] = registers[inst[2]] * inst[3]
	
func _op_MULir(inst):
	registers[inst[1]] = inst[2] * registers[inst[3]]
	
func _op_DIV(inst):
	registers[inst[1]] = registers[inst[2]] / registers[inst[3]]
	
func _op_DIVri(inst):
	registers[inst[1]] = registers[inst[2]] / inst[3]
	
func _op_DIVir(inst):
	registers[inst[1]] = inst[2] / registers[inst[3]]
	
func _op_MOD(inst):
	registers[inst[1]] = registers[inst[2]] % registers[inst[3]]
	
func _op_MODri(inst):
	registers[inst[1]] = registers[inst[2]] % inst[3]
	
func _op_MODir(inst):
	registers[inst[1]] = inst[2] % registers[inst[3]]
	
func _op_MIN(inst):
	registers[inst[1]] = min(registers[inst[2]], registers[inst[3]])
	
func _op_MINri(inst):
	registers[inst[1]] = min(registers[inst[2]], inst[3])
	
func _op_MINir(inst):
	registers[inst[1]] = min(inst[2], registers[inst[3]])
	
func _op_MAX(inst):
	registers[inst[1]] = max(registers[inst[2]], registers[inst[3]])
	
func _op_MAXri(inst):
	registers[inst[1]] = max(registers[inst[2]], inst[3])
	
func _op_MAXir(inst):
	registers[inst[1]] = max(inst[2], registers[inst[3]])
	
func _op_NEG(inst):
	# NEG rd rs
	registers[inst[1]] = -registers[inst[2]]
	
func _op_AND(inst):
	registers[inst[1]] = registers[inst[2]] & registers[inst[3]]
	
func _op_ANDri(inst):
	registers[inst[1]] = registers[inst[2]] & inst[3]
	
func _op_ANDir(inst):
	registers[inst[1]] = inst[2] & registers[inst[3]]
	
func _op_ORR(inst):
	registers[inst[1]] = registers[inst[2]] | registers[inst[3]]
	
func _op_ORRri(inst):
	registers[inst[1]] = registers[inst[2]] | inst[3]
	
func _op_ORRir(inst):
	registers[inst[1]] = inst[2] | registers[inst[3]]
	
func _op_NOT(inst: Array[int]):
	registers[inst[1]] = (not inst[2])
	
@warning_ignore("unused_parameter")
func _op_XOR(inst):
	push_error("_op_XOR Not implemented")
	
@warning_ignore("unused_parameter")
func _op_XORri(inst):
	push_error("_op_XORri Not implemented")
	
@warning_ignore("unused_parameter")
func _op_XORir(inst):
	push_error("_op_XORir Not implemented")
	
func _op_JMP(inst):
	ip = inst[1]
	
func _op_JGT(inst):
	ip = inst[3] if inst[1] > inst[2] else ip
	
func _op_JLT(inst):
	ip = inst[3] if inst[1] < inst[2] else ip
	
func _op_JEQ(inst):
	ip = inst[3] if inst[1] == inst[2] else ip
	
func _op_JNE(inst):
	ip = inst[3] if inst[1] != inst[2] else ip
	
func _op_JGE(inst):
	ip = inst[3] if inst[1] >= inst[2] else ip
	
func _op_JLE(inst):
	ip = inst[3] if inst[1] <= inst[2] else ip
	
func _op_JAL(_inst):
	push_error("_op_JAL Not implemented")
	
func _op_STR(inst):
	memory.set_at_address(registers[inst[2]],registers[inst[1]])
	
func _op_LDR(inst):
	registers[inst[1]] = memory.get_at_address(registers[inst[2]])
	
func _op_MOV(inst):
	# MOV rd rs
	registers[inst[1]] = registers[inst[2]]
	
func _op_END(_inst):
	running = false
	
func _op_LBL(_inst):
	# Placeholder
	pass
	
func _op_NOP(_inst):
	# Literally no-op
	pass
	
