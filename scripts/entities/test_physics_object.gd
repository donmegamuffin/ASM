extends RigidBody3D

@onready var cpu_component: CPUComponent = %CpuComponent
@onready var memory_component: MemoryComponent = %MemoryComponent
@onready var simple_movement_component: MMSimpleMovementComponent = %SimpleMovementComponent
@onready var simple_detector_component: MMSimplePlayerDetectorComponent = %SimplePlayerDetectorComponent

var asm_script_path: String = "res://scripts/ASM/move_to_player.asm"
var asm_script: String = ""

func _ready() -> void:
	load_asm_script_from_file()
	memory_component.resize(128)
	# Bind components
	cpu_component.bind_to_memory(memory_component)
	simple_movement_component.bind_to_memory(memory_component,32)
	simple_movement_component.bind_to_parent(self)
	simple_detector_component.bind_to_memory(memory_component,64)
	simple_detector_component.bind_to_parent(self)
	# Compile and load script
	var code = ASMCompiler.compile(asm_script)
	cpu_component.load_program(code)
	print(code.instructions)

func _process(_delta: float) -> void:
	cpu_component.tick()
	cpu_component.tick()
	cpu_component.tick()
	cpu_component.tick()

func load_asm_script_from_file():
	asm_script = FileAccess.open(asm_script_path,FileAccess.READ).get_as_text()
