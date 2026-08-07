@tool
extends Node
class_name TweenBounce

var tween:Tween
@export var host:Node
@export var frequency:float = 1.0
@export var amplitude:float = 0.5
@export var phase:float = 0.0
@export var random_phase:bool = true
@export var trans:Tween.TransitionType
@export var ease:Tween.EaseType
var start_position_v3:Vector3
var start_position_v2:Vector2
@export var active:bool = true:
	set(value):
		active = value
		if is_inside_tree() and value:
			bounce()
		elif is_inside_tree() and !value:
			tween.kill()
			host.scale = Vector3.ONE

func _ready() -> void:
	if !host:
		host = get_parent()
	if !host.position: return
	if host.position is Vector3:
		start_position_v3 = host.position
	elif host.position is float:
		start_position_v2 = host.position
	if random_phase:
		phase = randf_range(0,TAU)
		print(phase)
	if active:
		bounce()
	
func bounce():
	if tween: tween.kill()
	tween = create_tween()
	tween.set_ease(ease)
	tween.set_trans(trans)
	tween.tween_method(func(progress:float):
		if host.position is Vector3:
			host.position = start_position_v3 + Vector3.UP * amplitude * sin(progress * TAU + phase)
		elif host.position is float:
			host.position = start_position_v2 + Vector2.UP * amplitude * sin(progress * TAU + phase)
		,0.0,1.0,1.0/frequency )
	tween.tween_callback(func():
		if active:
			bounce()
		)
