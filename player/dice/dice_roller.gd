## To use the dice roller,  connect to the dice_rolled signal,
## then call roll, then await die_rolled which will return the result
extends Control
class_name DiceRoller

@export var top_container: FlowContainer
@export var middle_container: FlowContainer
@export var bottom_container: FlowContainer

## Emitted once dice have been rolled
signal dice_rolled(result:float)
 
## The number of times it should roll the 
## dice before accepting the result
var num_rolls_max: int = 10

var _num_rolls: int = 0
var _dice:Array[Dice]


func _init() -> void:
	hide()

## Will roll the provided dice num_rolls_max times and return 
func roll(dice:Array[Dice]):
	show()
	_clear_containers()
	_dice = dice
	_fill_containers(dice)
	
	_num_rolls = 0
	
	dice_rolled.connect(func(result):
		return result
		,CONNECT_ONE_SHOT
	)
	Maestro.play_sfx(SFXList.SFX.ROLL_DICE)
	_roll_dice() # rolls and emits result

func _roll_dice(finished:bool = false):
	show()
	_num_rolls += 1
	var result:float = 0
	for die:Dice in _dice:
		die.roll()
		result += die.result
	if finished:
		var roll_to_send:float = result
		print(roll_to_send)
		var tween:Tween = create_tween()
		Maestro.play_sfx(SFXList.SFX.DICE_ROLLED)
		
		tween.tween_interval(.75)
		tween.tween_callback(func():
			dice_rolled.emit(roll_to_send)
		)
		_num_rolls = 0
	else:
		var tween:Tween = create_tween()
		tween.tween_interval(.075)
		tween.parallel().tween_method(func(progress):
			for die in _dice:
				die.offset_transform_rotation = .2 * sin(progress * TAU)
			,0.0,1.0,.075)
		tween.tween_callback(_roll_dice.bind(_num_rolls >= num_rolls_max))

func _clear_containers() -> void:
	for die:Dice in _dice:
		die.get_parent().remove_child(die)

func _fill_containers(dice:Array[Dice]) -> void:
	var dice_count:int = dice.size()
	if dice_count > 9:
		push_error("Uh Oh! Dice viewer can't hold all these dice!")
		return
	if dice_count > 0:
		for i in (3 if dice_count >= 3 else dice_count):
			middle_container.add_child(dice[i])
	if dice_count > 3:
		for i in (3 if dice_count >= 6 else dice_count):
			bottom_container.add_child(dice[i+3])
	if dice_count > 6:
		for i in (3 if dice_count >= 9 else dice_count):
			top_container.add_child(dice[i+6])
