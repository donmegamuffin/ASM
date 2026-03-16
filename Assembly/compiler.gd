extends Node

class Program:
	var instructions: Array = []
	func _init(_instructions: Array):
		instructions = _instructions
		

func _coerce(token: String):
	if token in ASMInstructions.instruction_map.keys():
		return ASMInstructions.instruction_map[token]
	if token.lstrip("-").is_valid_int():
		return int(token)
	return token

func jit(source: String) -> Program:
	var raw_lines: Array = source.replace("\r\n", "\n").replace("\r", "\n").split("\n")
	var cleaned_lines: Array[String] = []

	for raw in raw_lines:
		var line = raw.get_slice("#",0).dedent()
		if line:
			cleaned_lines.append(line)

	var instructions = []
	var label_table: Dictionary[String, int] = {}

	var next_ip = 0
	for line in cleaned_lines:
		if line.rstrip(" ")[-1]==":":
			var label = line.dedent()
			label_table[label] = next_ip
			continue
		next_ip += 1
#
	for line in cleaned_lines:
		if line[-1] == ":":
			continue

		var parts = line.split(" ")
		var opcode_str = parts[0]
		var arg_tokens = parts.slice(1)

		var opcode := ASMInstructions.EInstruction.NOP
		if opcode_str in ASMInstructions.instruction_map.keys():
			opcode = ASMInstructions.instruction_map[opcode_str]
		else:
			print("Oopsiepoopsie!")
		var coerced_args = []
		for tok in arg_tokens:
			coerced_args.append(_coerce(tok))

		# Resolve label strings to integer addresses
		var resolved_args = []
		for arg in coerced_args:
			if arg is String and arg in label_table:
				resolved_args.append(label_table[arg])
			else:
				resolved_args.append(arg)

		instructions.append([opcode, resolved_args])

	return Program.new(instructions)
