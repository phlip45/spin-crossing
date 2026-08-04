extends Node3D

@onready var pulse: TweenPulse = $Pulse

func _on_point_of_interest_player_entered() -> void:
	pulse.active = true


func _on_point_of_interest_player_exited() -> void:
	pulse.active = false
