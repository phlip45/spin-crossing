class_name Spinner extends Node2D
static var ref: Spinner ; func _init() -> void:ref=self

signal spin_complete(angle: float)

const spin_force: float = 20.0
const spin_friction: float = 40.0
var angular_velocity: float = 0.0
var spinner_state: STATE = STATE.IDLE
var die_roll: int = 0

enum STATE {IDLE, READY, SLOWING, RESULT}

func next_state():
	match spinner_state:
		STATE.IDLE:
			angular_velocity = spin_force
			spinner_state = STATE.READY
		STATE.READY:
			spinner_state = STATE.SLOWING
		STATE.SLOWING:
			spinner_state = STATE.RESULT
		STATE.RESULT:
			spin_complete.emit(%SpinnerHand.rotation)
			print(%SpinnerHand.rotation)
			spinner_state = STATE.IDLE

func ready_for_spin(_die_roll: int) -> void:
	if spinner_state == STATE.IDLE:
		die_roll = _die_roll
		next_state()

func _process(delta: float) -> void:
	match spinner_state:
		STATE.IDLE:
			pass #wait for state change from signal
		STATE.READY:
			%SpinnerHand.rotate(angular_velocity * delta)
			if Input.is_action_just_pressed("activate"):
				next_state()
		STATE.SLOWING:
			angular_velocity = move_toward(angular_velocity, 0.0, spin_friction * delta)
			%SpinnerHand.rotate(angular_velocity * delta)
			if is_zero_approx(angular_velocity):
				next_state()
		STATE.RESULT:
			next_state()

func get_spin_vector() -> Vector3:
	return Vector3.FORWARD.rotated(Vector3.UP, %SpinnerHand.rotation)
