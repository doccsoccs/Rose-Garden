extends CharacterBody2D
class_name Player

# Movement
@export var speed = 600.0
var direction: Vector2 = Vector2.ZERO
var moving_left: bool = false
var moving_right: bool = false
var moving_up: bool = false
var moving_down: bool = false

# Interaction Detection
@onready var idetector = $InteractionDetector

func _input(_event):
	if Input.is_action_just_pressed("MoveLeft"):
		moving_left = true
		moving_right = false
	elif Input.is_action_just_pressed("MoveRight"):
		moving_left = false
		moving_right = true
	if Input.is_action_just_pressed("MoveUp"):
		moving_up = true
		moving_down = false
	elif Input.is_action_just_pressed("MoveDown"):
		moving_up = false
		moving_down = true
	
	if Input.is_action_just_released("MoveLeft"):
		moving_left = false
		if Input.is_action_pressed("MoveRight"):
			moving_right = true
	if Input.is_action_just_released("MoveRight"):
		moving_right = false
		if Input.is_action_pressed("MoveLeft"):
			moving_left = true
	if Input.is_action_just_released("MoveUp"):
		moving_up = false
		if Input.is_action_pressed("MoveDown"):
			moving_down = true
	if Input.is_action_just_released("MoveDown"):
		moving_down = false
		if Input.is_action_pressed("MoveUp"):
			moving_up = true

func _physics_process(delta):
	if Input.is_action_pressed("MoveLeft") and moving_left:
		direction += Vector2(-1,0)
	if Input.is_action_pressed("MoveRight") and moving_right:
		direction += Vector2(1,0)
	if Input.is_action_pressed("MoveUp") and moving_up:
		direction += Vector2(0,-1)
	if Input.is_action_pressed("MoveDown") and moving_down:
		direction += Vector2(0,1)
	
	velocity = direction.normalized() * speed * delta
	position += velocity
	
	# Rotate Interaction Detectord
	idetector.rotation = direction.angle()
	
	direction = Vector2.ZERO
	velocity = Vector2.ZERO
	
	move_and_slide()
