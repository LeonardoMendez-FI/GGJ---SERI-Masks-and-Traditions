extends CharacterBody3D
class_name Player

signal empty_energy
var energy:float = 600
# Audio para salto y pasos
@onready var jump_sound:AudioStreamPlayer = $JumpSound
@onready var footstep_sound:AudioStreamPlayer = $FootstepSound
@onready var camera_shaker:CameraShaker = $CameraShaker

@onready var debug_label: Label3D = $DebugLabel
@onready var animation_player: AnimationPlayer = $Model/AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback

@export var gravity:float = -70.0
@export var run_speed:float = 10.0
@export var rotation_speed:float = 2.7
@export var jump_velocity:float = 40.0
@export var air_control_player:float = 0.5
@export var double_jump_velocity:float = 20.0

var _is_moving:bool = false

var _can_double_jump:bool = false
var _is_jumping:bool = false

func _ready() -> void:
	# Activar el AnimationTree
	if animation_tree:
		animation_tree.active = true
		playback = animation_tree.get("parameters/playback")
		# Iniciar en IDLE
		if playback:
			playback.start("IDLE")
	else:
		print("ERROR: AnimationTree no encontrado")	
	
func _handle_movement() -> bool:
	
	var input: float = Input.get_axis("Down","Up")
	if is_equal_approx(input, 0.0):
		velocity.x = 0.0
		velocity.z = 0.0
		return false
	var direction: Vector3 = transform.basis.z * input
	var speed: float  = run_speed if is_on_floor() else run_speed * air_control_player
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	return true

func _handle_rotation(delta: float) -> bool:
	var input: float = Input.get_axis("Right", "Left")
	rotate_y(rotation_speed * input* delta)
	return !is_equal_approx(input, 0.0)

func _handle_input(delta: float) -> void:
	velocity.y += delta * gravity
	_handle_jump()
	var rotated: bool = _handle_rotation(delta)
	var moved: bool = _handle_movement()
	_is_moving = rotated or moved
	

func _handle_jump() -> void:
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			velocity.y = jump_velocity
			_can_double_jump = true
			_is_jumping = true
			# Reproducir sonido de salto
			if jump_sound:
				jump_sound.play()
		elif _can_double_jump and velocity.y >0:
			velocity.y += double_jump_velocity
			_can_double_jump = false
			_is_jumping = true
			# Reproducir sonido de salto (doble salto)
			if jump_sound:
				jump_sound.play()

func _update_animations() -> void:
	if not playback:
		return

	# Si está saltando o en el aire
	if not is_on_floor():
		playback.travel("JUMP")
		# Detener sonido de pasos si está en el aire
		if footstep_sound and footstep_sound.playing:
			footstep_sound.stop()
	# Si está en el suelo
	elif _is_moving:
		# Reproducir animación de caminar/correr
		playback.travel("RUN")
		# Reproducir sonido de pasos si no está ya sonando
		if footstep_sound and not footstep_sound.playing:
			footstep_sound.play()
	else:
		# Reproducir animación idle
		playback.travel("IDLE")
		# Detener sonido de pasos si está quieto
		if footstep_sound and footstep_sound.playing:
			footstep_sound.stop()

	# Resetear flag de salto cuando toca el suelo
	if is_on_floor() and _is_jumping:
		_is_jumping = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	_handle_input(delta)
	move_and_slide()
	_update_animations()
	_update_debug()

func _process(_delta: float) -> void:
	if energy <= 0:
		empty_energy.emit()

func _update_debug() -> void:
	var s: String  = "floor:%s\n" % [is_on_floor()]
	s += "vel: %s\n" % Utils.formatted_vec3(velocity)
	s += "pos: %s\n" % Utils.formatted_vec3(global_position)
	debug_label.text = s
