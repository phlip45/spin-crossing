class_name Bridge extends Node3D

@export var bridgename:String
@onready var bridge_center_wood: MeshInstance3D = $bridge_center_wood
@onready var collision_shape_3d: CollisionShape3D = $StaticBody3D/CollisionShape3D

var built: bool = false

func build() -> void:
	collision_shape_3d.set_deferred("disabled", true)
	built = true
	print("Building %s" % bridgename)
	bridge_center_wood.show()
