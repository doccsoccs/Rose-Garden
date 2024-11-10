extends CharacterBody2D
class_name Player

# Movement
@export var speed = 400.0
var direction: Vector2 = Vector2.ZERO
var moving_left: bool = false
var moving_right: bool = false
var moving_up: bool = false
var moving_down: bool = false

# Collisions
@onready var collision_component = $CollisionComponent

# Interactions
@onready var interaction_manager = $"../InteractionManager"
@onready var idetector = $InteractionDetector

func _ready():
	direction = Vector2(0,1)

func _input(event):
	# Interact
	if event.is_action_pressed("Interact"):
		interact()

func _physics_process(delta):
#region Movement Inputs
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
	
	if Input.is_action_pressed("MoveLeft") and moving_left:
		direction += Vector2(-1,0)
	if Input.is_action_pressed("MoveRight") and moving_right:
		direction += Vector2(1,0)
	if Input.is_action_pressed("MoveUp") and moving_up:
		direction += Vector2(0,-1)
	if Input.is_action_pressed("MoveDown") and moving_down:
		direction += Vector2(0,1)
#endregion
	
	# Move if direction is non-ZERO
	velocity = direction.normalized() * speed * delta
	position += velocity
	
	# Rotate Interaction Detector & Hitbox
	if velocity != Vector2.ZERO:
		collision_component.rotation = direction.angle()
		idetector.rotation = direction.angle()
	
	# Reset direction and velocity
	direction = Vector2.ZERO
	velocity = Vector2.ZERO
	
	move_and_slide()

# The player attempts to interact with an interactable object or NPC
func interact():
	interaction_manager.get_interaction()

# Interaction Signals
func _on_area_entered(area):
	interaction_manager.register_area(area)
func _on_area_exited(area):
	interaction_manager.unregister_area(area)
