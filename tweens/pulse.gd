extends Node
class_name TweenPulse

var tween:Tween
@export var host:Node
@export var amplitude:float = 0.2
@export var frequency:float = 1.0
@export var phase:float = 0.0
@export var random_phase:bool = true
@export var trans:Tween.TransitionType
@export var ease:Tween.EaseType
@export var active:bool = true:
	set(value):
		active = value
		if is_inside_tree() and value:
			pulse()
		elif is_inside_tree() and !value:
			tween.kill()
			host.scale = Vector3.ONE

func _ready() -> void:
	if !host:
		host = get_parent()
	if random_phase:
		phase = randf_range(0,TAU)
		print(phase)
	if active:
		pulse()
	
func pulse():
	if tween: tween.kill()
	tween = create_tween()
	#tween.set_ease(ease)
	tween.set_trans(trans)
	print("Tween duration: ", float(1.0/frequency))
	tween.tween_method(func(progress:float):
		if host.scale is Vector3:
			host.scale = Vector3.ONE + Vector3.ONE * amplitude * sin(progress * TAU + phase)
		elif host.scale is Vector2:
			host.scale = Vector2.ONE + Vector2.ONE * amplitude * sin(progress * TAU + phase)
		,0.0,1.0,1.0/frequency )
	tween.tween_callback(func():
		if active:
			pulse()
		)
