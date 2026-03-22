class_name MMSimpleMovementComponent extends MemMappedComponentBase

var dx_velocity:int = 0
var dy_velocity:int = 0
var dz_velocity:int = 0


func _on_memory_value_change(address: int, value: int):
	var offset_address:int = address-address_offset
	# Set run forwards
	if offset_address == 0:
		dx_velocity = value
	elif offset_address == 1:
		dy_velocity = value
	elif offset_address == 2:
		dz_velocity = value

func _process(delta: float) -> void:
	var parent_obj_3dnode = parent_obj as Node3D
	if parent_obj_3dnode:
		parent_obj_3dnode.position.x += dx_velocity*delta
		parent_obj_3dnode.position.y += dy_velocity*delta
		parent_obj_3dnode.position.z += dz_velocity*delta
