extends RigidBody3D

@onready var cpu_component: CPUComponent = %CpuComponent
@onready var memory_component: MemoryComponent = %MemoryComponent
@onready var simple_movement_component: MMSimpleMovementComponent = %SimpleMovementComponent

var asm_script: String = "MAIN:
	ADD r1 r1 1
	ADD r2 r0 32
	STR r1 r2
	JMP MAIN	"

func _ready() -> void:
	memory_component.resize(128)
	cpu_component.bind_to_memory(memory_component)
	simple_movement_component.bind_to_memory(memory_component,32)
	simple_movement_component.bind_to_parent(self)
	print(asm_script)
	var code = ASMCompiler.compile(asm_script)
	cpu_component.load_program(code)
	print(code.instructions)

func _process(delta: float) -> void:
	cpu_component.tick()
	print(cpu_component.registers[1])
