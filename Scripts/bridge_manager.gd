extends Node

signal build_bridge(coins_collected:int,bridges_build:int)
func _on_point_of_interest_player_entered() -> void:
	print("trybuild bridge")
	build_bridge.emit(
		Player.coins_collected,
		Player.bridges_built)


func _on_point_of_interest_player_exited() -> void:
	pass # Replace with function body.
