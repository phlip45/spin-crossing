extends Control
class_name SpinnerOverlay

@export var spinner: Spinner
@export var dice_roller: DiceRoller

@onready var dice_roller_center: Control = $DiceRollerCenter
@onready var dice_roller_spinner_location: Control = $DiceRollerSpinnerLocation

var dr_tween:Tween

signal spinner_result(direction:Vector3,distance:float)

func take_turn() -> void:
	move_dice_roller(dice_roller_spinner_location, dice_roller_center)
	dice_roller.roll(Global.player.dice)
	var distance = await dice_roller.dice_rolled
	
	move_dice_roller(dice_roller_center, dice_roller_spinner_location)
	print("Got Distance", str(distance))
	spinner.spin()
	var direction = await spinner.spin_complete
	print("Got direction", str(direction))
	print("emitting spinner result %s,%s" % [direction,distance])
	spinner_result.emit(direction,distance)
	return

func move_dice_roller(from:Control,to:Control):
	if dr_tween: dr_tween.kill()
	dr_tween = create_tween()
	dr_tween.set_trans(Tween.TRANS_BACK)
	dr_tween.tween_property(dice_roller,"offset_transform_position", to.position - from.position, .5)
	dr_tween.tween_callback(func():
		dice_roller.offset_transform_position = Vector2.ZERO
		dice_roller.reparent(to,false)
	)
	
