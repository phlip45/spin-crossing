extends Area3D

signal coin_collected

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		var player:Player = body as Player
		coin_collected.emit()
		player.collect_coin()
		Maestro.play_sfx(SFXList.SFX.COIN_PICKUP)
		queue_free()
