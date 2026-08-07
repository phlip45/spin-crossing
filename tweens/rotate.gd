@tool
extends Node
class_name TweenRotate

var tween:Tween
@export var host:Node
@export var frequency:float = 1.0
@export var phase:float = 0.0
@export var clockwise:bool = true
@export var random_phase:bool = true
@export var trans:Tween.TransitionType
@export var ease:Tween.EaseType
var start_rotation_v3:Vector3
var start_rotation_float:float
@export var active:bool = true:
	set(value):
		active = value
		if is_inside_tree() and value:
			rotato()
		elif is_inside_tree() and !value:
			tween.kill()
			host.scale = Vector3.ONE

func _ready() -> void:
	if !host:
		host = get_parent()
	if !host.rotation: return
	if host.rotation is Vector3:
		start_rotation_v3 = host.rotation
	elif host.rotation is float:
		start_rotation_float = host.rotation
	if random_phase:
		phase = randf_range(0,TAU)
		print(phase)
	if active:
		rotato()
	
func rotato():
	if tween: tween.kill()
	tween = create_tween()
	tween.set_ease(ease)
	tween.set_trans(trans)
	tween.tween_method(func(progress:float):
		if host.rotation is Vector3:
			host.rotation = start_rotation_v3 + Vector3.UP * (-1 if clockwise else 1) * (progress * TAU + phase)
		elif host.rotation is float:
			host.rotation = start_rotation_float + (-1 if clockwise else 1) *(progress * TAU + phase)
		,0.0,1.0,1.0/frequency )
	tween.tween_callback(func():
		if active:
			rotato()
		)
