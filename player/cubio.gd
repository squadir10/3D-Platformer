extends CharacterBody3D

const MAX_SPEED = 3
const JUMP_SPEED = 5
const ACCELERATION = 2
const DECELERATION = 4

@onready var camera = $Target/Camera3D
@onready var gravity = -ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var start_position = position

func _physics_process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reset_position"):
		position = start_position

	var dir = Vector3()
	dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	dir.z = Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")

	# Adjust camera basis
	var cam_basis = camera.global_transform.basis
	var basis = cam_basis.rotated(cam_basis.x, -cam_basis.get_euler().x)
	dir = basis * (dir)

	if dir.length_squared() > 1:
		dir /= dir.length()

	velocity.y += delta * gravity  # Apply gravity directly to velocity

	var hvel = velocity
	hvel.y = 0

	var target = dir * MAX_SPEED
	var acceleration
	if dir.dot(hvel) > 0:
		acceleration = ACCELERATION
	else:
		acceleration = DECELERATION


	hvel = hvel.lerp(target, acceleration * delta)
	velocity.x = hvel.x
	velocity.z = hvel.z

	move_and_slide()

	if is_on_floor() and Input.is_action_pressed("jump"):
		velocity.y = JUMP_SPEED
