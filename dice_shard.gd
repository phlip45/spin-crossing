@tool
extends Node3D
class_name DiceShard

@export var sprite_3d: Sprite3D
@export var dice_side:DiceSide

func _ready() -> void:
	if Engine.is_editor_hint():
		sprite_3d.texture = dice_side.texture
	pass
