extends Node

class Program:
	var instructions: Array = []
	func _init(_instructions: Array = []):
		instructions = _instructions
		

func _coerce(token: String):
	if token in ASMInstructions.instruction_map.keys():
		return ASMInstructions.instruction_map[token]
	if token.lstrip("-").is_valid_int():
		return int(token)
	return token
	
func _compile_instruction_line(line: Array[String], label_table: Dictionary)->Array:
	# Assumes line split with no whitespace, with perfectly split such
	# any number of args, but everything past a # can contain whitespace and is
	# always treated as a comment. The line should have structure such as 
	# [ op string, arg1, arg2, arg3, comment ]  with variable args and optional
	# comment. The args will dictate whether we use the raw version of an 
	# instruction, or the alternative immediate versions (suffix ir or rr)
	
	# Will return whether there has been an error, and the output results.
	
	# First things first, let's identify how many things there are, and what 
	# "type" are they (instruction, register, immediate, comment, label)
	var bHasParsingError: bool = false
	var optypes: Array = []
	var i: int = 0
	for operand: String in line:
		if i == 0 and len(operand)==3:
			if operand in ASMInstructions.instruction_map.keys():
				optypes.append(ASMInstructions.EOperandType.INSTRUCTION)
			else: # Unknown OP
				optypes.append(ASMInstructions.EOperandType.UNKNOWN)
		elif operand[0] == "r":
			optypes.append(ASMInstructions.EOperandType.REGISTER)
		elif operand.is_valid_int():
			optypes.append(ASMInstructions.EOperandType.IMMEDIATE)
		elif operand[0] == "#":
			optypes.append(ASMInstructions.EOperandType.COMMENT)
		elif operand in label_table.keys():
			optypes.append(ASMInstructions.EOperandType.LABEL)
		else: 
			optypes.append(ASMInstructions.EOperandType.UNKNOWN)
			bHasParsingError = true
		i+=1
	
	# Then we'll check to make sure we're using the right "flavour" of 
	# instruction. Under the hood, ADD will be replaced with ADDir or ADDri if
	# and immediate is found instead of a register.
	if len(line) >= 4:
		# Normal rr instruction
		if optypes[2] == ASMInstructions.EOperandType.REGISTER and \
		optypes[3] == ASMInstructions.EOperandType.REGISTER:
			pass
		# ri instruction
		elif optypes[2] == ASMInstructions.EOperandType.REGISTER and \
		optypes[3] == ASMInstructions.EOperandType.IMMEDIATE:
			line[0] = line[0]+"ri"
		# ir instruction
		elif optypes[2] == ASMInstructions.EOperandType.IMMEDIATE and \
		optypes[3] == ASMInstructions.EOperandType.REGISTER:
			line[0] = line[0]+"ir"
	
	# Now we finally compile the instructions for return. These will be all
	# integers in the final instruction like [5, 2, 3, 7] which under the hood
	# will get converted to ["SUBri", "r2", "r3", 7] for processing because
	# types are inferred from the instruction.
	var compiled_instruction_line: Array[int] = []
	for idx in range(len(line)):
		match optypes[idx]:
			ASMInstructions.EOperandType.INSTRUCTION:
				compiled_instruction_line.append(ASMInstructions.instruction_map[line[idx]])
			ASMInstructions.EOperandType.REGISTER:
				compiled_instruction_line.append(ASMInstructions.register_map[line[idx]])
			ASMInstructions.EOperandType.IMMEDIATE:
				compiled_instruction_line.append(int(line[idx]))
			ASMInstructions.EOperandType.LABEL:
				if line[idx] in label_table.keys():
					compiled_instruction_line.append(label_table[line[idx]])
				else:
					compiled_instruction_line.append(null)
					bHasParsingError = true
			_:
				continue
	return [bHasParsingError,compiled_instruction_line]

func compile(source: String) -> Program:
	# Basically just strip all the whitespace
	var raw_lines: Array = source.replace("\r\n", "\n").replace("\r", "\n").split("\n")
	var cleaned_lines: Array[String] = []

	# Remove comments
	for raw in raw_lines:
		var line = raw.get_slice("#",0).dedent()
		if line:
			cleaned_lines.append(line)

	# We need to setup our outputs and a map for us to map the label locations
	# in the final step of replacing labels with position indices
	var instructions = []
	var label_table = {}

	var instruction_idx = 0
	for line in cleaned_lines:
		if line.rstrip(" \n")[-1]==":":
			var label = line.dedent().rstrip(":")
			label_table[label] = instruction_idx
			continue
		instruction_idx += 1
#
	for line in cleaned_lines:
		# Skip if line is empty or a label
		if line[-1] == ":" or len(line)==0:
			continue
		var result = _compile_instruction_line(line.split(" ",false), label_table)
		var bHasError: bool = result[0]
		var instruction_line = result[1]
		
		if bHasError:
			return Program.new()
		instructions.append(instruction_line)

	return Program.new(instructions)
