class_name MemoryComponent extends Node

signal value_at_address_changed(address: int, value: int)

var _memory: Array[int] = []

func _init(size:int = 128) -> void:
	_memory.resize(size)
	_memory.fill(0)
	
func resize(size:int) -> void:
	_memory.resize(size)
	_memory.fill(0)
	
func reset():
	_memory.fill(0)
	
func set_at_address(address: int, value: int):
	if address<len(_memory):
		_memory[address] = value
		value_at_address_changed.emit(address, value)
	else:
		push_error("Tried to access _memory address outside of address space.")

func get_at_address(address: int):
	if address<len(_memory):
		return _memory[address]
	else:
		push_error("Tried to access _memory address outside of address space.")
