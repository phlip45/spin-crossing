extends Node2D
class_name Spinner
#static var ref: Spinner ; func _init() -> void:ref=self

signal spin_complete(direction: Vector3)

const spin_force: float = 20.0
const spin_friction: float = 40.0
@export var angular_velocity: float = 1.0
var state: State = State.IDLE
var die_roll: int = 0

enum State { IDLE, READY, SLOWING, RESULT }

func spin():
	if state != State.IDLE:
		push_error("Tried to spin when spin wasn't ready")
		return
	print("Changing Spinner to Ready")
	change_state(State.READY)

func change_state(new_state:State):
	state = new_state
	match state:
		State.IDLE:
			angular_velocity = spin_force
			print("Spinner Idle")
			
		State.READY:
			print("Spinner Ready")
			
			set_visible(true)
		State.SLOWING:
			print("Spinner slowing")
		State.RESULT:
			get_tree().create_timer(0.88).timeout.connect(func():
				var direction:Vector3 = rotation_to_vector3(%SpinnerHand.rotation)
				spin_complete.emit(direction)
				print(direction)
				set_visible(false)
				change_state(State.IDLE)
			)



func _process(delta: float) -> void:
	match state:

		State.IDLE:
			pass #wait for state change from signal
		State.READY:
			%SpinnerHand.rotate(angular_velocity * delta)
			if Input.is_action_just_pressed("activate"):
				change_state(State.SLOWING)
		State.SLOWING:
			angular_velocity = move_toward(angular_velocity, 0.0, spin_friction * delta)
			%SpinnerHand.rotate(angular_velocity * delta)
			if is_zero_approx(angular_velocity):
				change_state(State.RESULT)
		State.RESULT:
			pass

func rotation_to_vector3(angle: float) -> Vector3:
	return Vector3(cos(angle),0.0, sin(angle))
