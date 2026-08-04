extends Node
class_name TweenPulse

var tween:Tween
@export var host:Node3D
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
	if active:
		pulse()
	
func pulse():
	if tween: tween.kill()
	tween = create_tween()
	tween.tween_method(func(progress:float):
		host.scale = Vector3.ONE + Vector3.ONE * .2 * sin(progress)
		,0.0,TAU,2.0 )
	tween.tween_callback(func():
		if active:
			pulse()
		)
