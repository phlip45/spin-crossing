extends Node2D
class_name Dice
#static var ref: Dice ; func _init() -> void:ref=self

## To use the dice, call Dice.ref.roll_die()
## When it's finished, it will return the int between 1-6
## through a signal: die_rolled(result:int)

signal die_rolled(result:int)

@onready var _dice_sprite: AnimatedSprite2D = %Dice_AnimatedSprite2D
 
const _MAX_SPINS: int = 35
var _spins: int = 0
var _roll: int = 0

func roll():
	die_rolled.connect(func(result):
		return result
		,CONNECT_ONE_SHOT
	)
	roll_die()

func roll_die(finished:bool = false):
	_roll = randi_range(0,5)
	_dice_sprite.frame = _roll
	if finished:
		var roll_to_send: int = _roll + 1
		print(roll_to_send)
		var tween:Tween = create_tween()
		tween.tween_interval(.08)
		tween.tween_callback(func():
			set_visible(false)
			die_rolled.emit(roll_to_send)
		)
		
		_roll = 0
		_spins = 0

	else:
		set_visible(true)
		_spins += 1
		var tween:Tween = create_tween()
		tween.tween_interval(.08)
		tween.tween_callback(roll_die.bind(_spins >= _MAX_SPINS))
