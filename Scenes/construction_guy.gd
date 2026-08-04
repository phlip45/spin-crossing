extends Node3D
@onready var message_panel_container: PanelContainer = %Message_PanelContainer

@export var bridges_to_build:Array[Bridge]
@onready var message_label: Label = %Message_Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_point_of_interest_player_entered(player:Player) -> void:
	animation_player.play("idle")
	message_panel_container.show()
	if player.coins_collected > 0:
		player.remove_coin()
		bridges_to_build[0].build()
		bridges_to_build.pop_front()
		if bridges_to_build.size() == 0:
			#End Level, we win!
			message_label.text = "YOU WIN!"
			pass

func _on_point_of_interest_player_exited() -> void:
	animation_player.stop()
	message_panel_container.hide()
