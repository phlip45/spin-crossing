@tool
extends Area3D
class_name PointOfInterest

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

var player:Player

signal player_entered(player:Player)
signal player_exited

@export var radius:float:
	set(value):
		radius = value
		if Engine.is_editor_hint():
			recalc()		

func recalc():
	if !collision_shape_3d: return
	var sphere:SphereShape3D = collision_shape_3d.shape
	sphere.radius = radius

func has_player() -> bool:
	return player != null

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		player = body as Player
		player_entered.emit(player)

func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		player_exited.emit()
		player = null
