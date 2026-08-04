extends Node3D

func _process(_delta: float) -> void:
	rotation.y = Camera.ref.get_yaw()
	
	print(rotation.y)
