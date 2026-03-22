extends RigidBody3D

@onready var cpu_component: CPUComponent = %CpuComponent
@onready var memory_component: MemoryComponent = %MemoryComponent
@onready var simple_movement_component: MMSimpleMovementComponent = %SimpleMovementComponent

var asm_script: String = "
# Set memory location address
ADD r2 r0 34		# r2 holds z-axis address
ADD r3 r0 15		# r3 holds max speed
NEG r4 r3		# r4 holds min speed
INCREASE:
	ADD r1 r1 1
	STR r1 r2
	JLE r1 r3 INCREASE	
DECREASE:
	SUB r1 r1 1
	STR r1 r2
	JGE r1 r4 DECREASE
	JMP INCREASE"


func _ready() -> void:
	memory_component.resize(128)
	cpu_component.bind_to_memory(memory_component)
	simple_movement_component.bind_to_memory(memory_component,32)
	simple_movement_component.bind_to_parent(self)
	print(asm_script)
	var code = ASMCompiler.compile(asm_script)
	cpu_component.load_program(code)
	print(code.instructions)

func _process(_delta: float) -> void:
	cpu_component.tick()
	print(cpu_component.registers[1])
