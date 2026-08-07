extends Resource
class_name DiceSide

@export var type:Type
@export var roll_type:RollType
@export var value:float
@export var texture:Texture2D

enum Type {
	NULL,
	PIP_ONE,
	PIP_TWO,
	PIP_THREE,
	PIP_FOUR,
	PIP_FIVE,
	PIP_SIX,
	PIP_SEVEN,
	PIP_EIGHT,
	PIP_NINE,
	PIP_TEN,
}

enum RollType {
	NULL,
	STANDARD,
}

var roll_type_to_callable:Dictionary[RollType, Callable] = {
	RollType.NULL: 
		func() -> float: 
			push_error("Tried to call die face "+
			"that wasn't set")
			return 0,
	RollType.STANDARD:
		func() -> float: return value,
}

func evaluate() -> float:
	return roll_type_to_callable[roll_type].call()

func get_ident() -> String:
	return "%s %s %s" % [type,roll_type,value]
