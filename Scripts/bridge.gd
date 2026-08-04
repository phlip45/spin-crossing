extends Node3D
@onready var _bridge_model: MeshInstance3D = %bridge_center_wood
@onready var _collision: CollisionShape3D = %CollisionShape3D

@export var bridge_number: int

var _built: bool = false

func build(
coins:int,bridges_built:int
) -> bool:
	if coins > 0 \
	and not _built \
	and bridges_built+1 == bridge_number:
		_bridge_model.show()
		_collision.disable = true
		_built = true
		return true
	return false
		
