extends CenterContainer
class_name SpinnerOverlay

@onready var spinner: Spinner = $SubViewportContainer/SubViewport/Spinner
@onready var dice: Dice = $SubViewportContainer/SubViewport/Dice

signal spinner_result(direction:Vector3,distance:float)

func take_turn() -> void:
	dice.roll()
	var distance = await dice.die_rolled
	print("Got Distance", str(distance))
	spinner.spin()
	var direction = await spinner.spin_complete
	print("Got direction", str(direction))
	
	spinner_result.emit(direction,distance)
	return
