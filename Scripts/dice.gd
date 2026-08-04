class_name Dice extends Node2D
static var ref: Dice ; func _init() -> void:ref=self

## To use the dice, call Dice.ref.roll_die()
## When it's finished, it will return the int between 1-6
## through a signal: die_rolled(result:int)

signal die_rolled(result:int)

@onready var _dice_sprite: AnimatedSprite2D = %Dice_AnimatedSprite2D

const _MAX_SPINS: int = 35
@onready var _timer: Timer = %Timer

var _spins: int = 0
var _roll: int = 0

func _ready() -> void:
	_timer.timeout.connect(_on_timeout)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("activate"):
		roll_die()

func roll_die(emit:bool = false) -> int:
	_roll = randi_range(0,5)
	_dice_sprite.frame = _roll
	if emit:
		var roll_to_send: int = _roll + 1
		_timer.stop()
		die_rolled.emit(roll_to_send)
		print(roll_to_send)
		_roll = 0
		_spins = 0
	else:
		_timer.start(.08)
		
	return _roll

func _on_timeout() -> void:
		_spins +=1
		if _spins < _MAX_SPINS:
			roll_die()
		else:
			roll_die(true)
