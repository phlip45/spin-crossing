extends CanvasLayer

@onready var _message_container: PanelContainer = %Message_PanelContainer


func _on_point_of_interest_player_entered() -> void:
	_message_container.show()


func _on_point_of_interest_player_exited() -> void:
	_message_container.hide()
