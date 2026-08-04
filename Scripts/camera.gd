class_name Camera extends Camera3D
static var ref: Camera ; func _init() -> void:ref=self


func get_yaw() -> float:
	return rotation.y
