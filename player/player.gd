extends CharacterBody3D
class_name Player

@export var speed = 5.0
@export var sprint:float = 10.0
@export var sprint_max:float = 10.0
@export var acceleration:float = 1.0
@export var jump_strength:float = 10.0
var debug:bool
const JUMP_VELOCITY = 4.5
var mouse_move:Vector2
@onready var camera_3d: Camera3D = $Camera3D
@onready var ground_cast: RayCast3D = $GroundCast
@onready var facing_arrow_pivot: Node3D = $FacingArrowPivot

var coins_collected:int

signal move_complete

var state:State
var moving_tween:Tween
enum State{
	NULL,
	MOVING,
	IDLE,
}

var debug_facing:Direction

enum Direction{
	NULL,
	LEFT,
	FORWARD,
	RIGHT,
	BACK,
}

func _input(event:InputEvent):
	if Input.is_action_just_pressed("escape"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("action_1"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event is InputEventMouseMotion and Engine.time_scale > 0:
		var amount_to_add =  event.relative if event.relative.length() > 0.2 else Vector2.ZERO
		mouse_move += amount_to_add * 1.5 * .003
	if Input.is_action_just_pressed("debug_1"):
		debug = true
func _process(delta: float) -> void:
	if debug:
		move(delta)
	if Input.is_action_just_pressed("debug_2"):
		if debug_facing == Direction.NULL or debug_facing == Direction.BACK:
			spinner_move(Vector3.RIGHT,10)
			debug_facing = Direction.RIGHT
		elif debug_facing == Direction.RIGHT:
			debug_facing = Direction.FORWARD
			spinner_move(Vector3.FORWARD,10)
		elif debug_facing == Direction.FORWARD:
			debug_facing = Direction.LEFT
			spinner_move(Vector3.LEFT,10)
		elif debug_facing == Direction.LEFT:
			debug_facing = Direction.BACK
			spinner_move(Vector3.BACK,10)
			
	mouse_look(delta)

func move(delta:float):
	pass
	var input_dir:Vector2 = Input.get_vector("left", "right", "forward", "back")
	var vert_dir:float = Input.get_axis("down","up")
	var direction:Vector3 = (camera_3d.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var horiz_speed:Vector2 = Vector2(direction.x, direction.z).normalized()
	if direction or vert_dir:
		velocity.x = horiz_speed.x * speed * sprint
		#velocity.y = vert_dir * speed
		velocity.z = horiz_speed.y * speed * sprint
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		#velocity.y = 0
		velocity.z = move_toward(velocity.z, 0, speed)
	if velocity.length() > 0 and Input.is_action_pressed("sprint"):
		sprint = move_toward(sprint, sprint_max, acceleration * delta)
	else:
		sprint = move_toward(sprint, speed, acceleration * delta)
	if ground_cast.is_colliding() and Input.is_action_just_pressed("jump"):
		velocity.y += jump_strength
	move_and_slide()

func mouse_look(_delta:float):
		camera_3d.rotation.y -= mouse_move.x
		camera_3d.rotation.x -= mouse_move.y
		camera_3d.rotation.x = clampf(camera_3d.rotation.x, -PI/3, PI/3)
		mouse_move = Vector2.ZERO

func spinner_move(direction:Vector3, distance:float):
	if state == State.MOVING:
		push_error("Tried moving while already moving")
		return
	state = State.MOVING
	facing_arrow_pivot.look_at(position + direction)
	
	moving_tween = create_tween()
	direction = direction.normalized()
	moving_tween.tween_property(
		self, 
		"position", 
		position + direction * distance, 
		1.0
	)
	moving_tween.tween_callback(func():
		state = State.IDLE
		move_complete.emit()
	)

func collect_coin():
	coins_collected += 1
	Maestro.play_sfx(SFXList.SFX.POP)
