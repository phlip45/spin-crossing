class_name Bridge extends Node3D

static var _bridge_model: MeshInstance3D
static var _collision: CollisionShape3D

@export var bridge_number: int

func _ready() -> void:
	%BridgeManager.build_bridge.connect(_on_build)
	_bridge_model = %bridge_center_wood
	_collision = %CollisionShape3D

var _built: bool = false

func _on_build(
coins:int,bridges_built:int
) -> void:
	print("trying to build bridge ",bridge_number,"...")
	if coins > 0 \
	and not _built \
	and bridges_built+1 == bridge_number:
		print("building bridge ",bridge_number," because bridges built are ",bridges_built)
		_bridge_model.show()
		_collision.disabled = true
		_built = true
		Player.bridges_built +=1
		
