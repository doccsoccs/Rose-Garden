extends CharacterBody2D
class_name Player

# Movement
@export var speed = 400.0
var direction: Vector2 = Vector2.ZERO

# Collisions
@onready var collision_component = $CollisionComponent

# Interactions
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
		MoveBetweenScenes.moving_left = true
		MoveBetweenScenes.moving_right = false
	if Input.is_action_just_pressed("MoveRight"):
		MoveBetweenScenes.moving_left = false
		MoveBetweenScenes.moving_right = true
	if Input.is_action_just_pressed("MoveUp"):
		MoveBetweenScenes.moving_up = true
		MoveBetweenScenes.moving_down = false
	if Input.is_action_just_pressed("MoveDown"):
		MoveBetweenScenes.moving_up = false
		MoveBetweenScenes.moving_down = true
	
	if Input.is_action_just_released("MoveLeft"):
		MoveBetweenScenes.moving_left = false
		if Input.is_action_pressed("MoveRight"):
			MoveBetweenScenes.moving_right = true
	if Input.is_action_just_released("MoveRight"):
		MoveBetweenScenes.moving_right = false
		if Input.is_action_pressed("MoveLeft"):
			MoveBetweenScenes.moving_left = true
	if Input.is_action_just_released("MoveUp"):
		MoveBetweenScenes.moving_up = false
		if Input.is_action_pressed("MoveDown"):
			MoveBetweenScenes.moving_down = true
	if Input.is_action_just_released("MoveDown"):
		MoveBetweenScenes.moving_down = false
		if Input.is_action_pressed("MoveUp"):
			MoveBetweenScenes.moving_up = true
	
	if Input.is_action_pressed("MoveLeft") and MoveBetweenScenes.moving_left:
		direction += Vector2(-1,0)
	if Input.is_action_pressed("MoveRight") and MoveBetweenScenes.moving_right:
		direction += Vector2(1,0)
	if Input.is_action_pressed("MoveUp") and MoveBetweenScenes.moving_up:
		direction += Vector2(0,-1)
	if Input.is_action_pressed("MoveDown") and MoveBetweenScenes.moving_down:
		direction += Vector2(0,1)
#endregion
	if !DialogueManager.in_dialog:
		# Move if direction is non-ZERO
		velocity = direction.normalized() * speed * delta
		position += velocity
		
		# Rotate Interaction Detector
		if velocity != Vector2.ZERO:
			idetector.rotation = direction.angle()
	
	# Reset direction and velocity
	direction = Vector2.ZERO
	velocity = Vector2.ZERO
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		# Don't slide when moving into interactables
		if collision.get_collider() is Interactable:
			pass

# The player attempts to interact with an interactable object or NPC
func interact():
	if InteractionManager.can_interact:
		InteractionManager.get_interaction()

# Interaction Signals
func _on_area_entered(area):
	InteractionManager.register_area(area)
func _on_area_exited(area):
	InteractionManager.unregister_area(area)
