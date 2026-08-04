extends Node

@onready var _animation_player: AnimationPlayer = $"../construction_guy/AnimationPlayer"


func _on_point_of_interest_player_entered() -> void:
	_animation_player.play("idle")


func _on_point_of_interest_player_exited() -> void:
	_animation_player.stop()
