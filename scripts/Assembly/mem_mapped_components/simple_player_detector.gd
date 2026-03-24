class_name MMSimplePlayerDetectorComponent extends MemMappedComponentBase

# Address space:
# 00 - OUT X distance
# 01 - OUT Y distance
# 02 - OUT Z distance
# 03 - OUT Euclidean distance
# 04 - OUT DetectionArea Radius
# 
# 10 - IN Set DetectionAreaRadius

@onready var detection_area: Area3D = %DetectionArea3D
@onready var detection_area_shape: SphereShape3D = %CollisionShape3D.shape
var players_in_area: Array[CharacterEntityBase] = []

func _on_memory_value_change(address: int, value: int):
	var relative_address = address-address_offset
	if relative_address == 10:
		detection_area_shape.radius = value
		
func _process(_delta: float) -> void:
	var displacement: Vector3 = _get_vector_to_nearest_player_entity()
	bound_memory.set_at_address(address_offset+0,round(displacement.x))
	bound_memory.set_at_address(address_offset+1,round(displacement.y))
	bound_memory.set_at_address(address_offset+2,round(displacement.z))
	bound_memory.set_at_address(address_offset+3,round(displacement.length()))
	bound_memory.set_at_address(address_offset+4,round(detection_area_shape.radius))

func _get_vector_to_nearest_player_entity()->Vector3:
	var dists: Array[float] = []
	for player in players_in_area:
		dists.append(parent_obj.position.distance_to(player.position))
	if len(dists)==0:
		return Vector3.ZERO
	var argmin: int = MathUtils.argmin(dists)
	return players_in_area[argmin].position-parent_obj.position

func _on_area_3d_body_entered(body: Node3D) -> void:
	var other = body as CharacterEntityBase
	if not other:
		return
	players_in_area.append(other)

func _on_area_3d_body_exited(body: Node3D) -> void:
	var other = body as CharacterEntityBase
	if not other:
		return
	players_in_area.erase(other)
