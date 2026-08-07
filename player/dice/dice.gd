extends Control
class_name Dice

@export var face: Sprite2D

## Result is the value this dice had the last time
## it was rolled. It is exported so the default value
## can be set.
@export var result:float
@export var sides:Array[DiceSide]

## Called when the rolled dice are have finished animating
signal dice_rolled(_result:float)

## Called when sides of the dice have changed
signal sides_changed(_sides:Array[DiceSide])
func _init() -> void:
	## the dice viewer will handle making these visible
	## and not visible after initialization
	pass
	#hide()

## This will be called when the dice need to be rolled.
## It needs to emit dice_rolled
func roll() -> void:
	var chosen_side:DiceSide = sides.pick_random()
	result = chosen_side.evaluate()
	face.texture = chosen_side.texture
	dice_rolled.emit(result)
	
## This will add a new side to the dice
func add_side(new_side:DiceSide, silent:bool = false) -> void:
	sides.append(new_side)
	if not silent:
		sides_changed.emit(sides)

## This will remove a side from the dice. Silent will do so without emitting
## sides_changed
func remove_side(doomed_side:DiceSide, silent:bool = false) -> void:
	var found_side_index:int = sides.find_custom(func(s:DiceSide):
		return s.get_ident() == doomed_side.get_ident()
	)
	if found_side_index == -1:
		push_error("tried to remove side %s but couldn't find it" %
		 doomed_side.get_ident()) 
	if not silent:
		sides_changed.emit(sides)

## This will first remove a side and then add a side
func replace_side(old_side:DiceSide, new_side:DiceSide) -> void:
	remove_side(old_side, true)
	add_side(new_side, true)
	sides_changed.emit(sides)
