@abstract
class_name MemMappedComponentBase extends Node3D

var start_address: int = -1
var end_address: int = -1
var address_offset: int = 0
var parent_obj: Node = null
var bound_memory: MemoryComponent = null

func bind_to_memory(memory: MemoryComponent, addr_offset: int = 0):
	bound_memory = memory
	address_offset = addr_offset
	bound_memory.value_at_address_changed.connect(_on_memory_value_change)
	
func bind_to_parent(object: Node):
	reparent(object)
	self.parent_obj = get_parent()
	
@abstract
func _on_memory_value_change(address: int, value: int)
