extends CharacterBody2D
class_name PlayerBody

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -300.0
@export var ACCELERATION_SPEED = 800;
@export var DASH_SPEED = 400;
@export var WALL_PUSH_SPEED = 200;
var max_jumps = 2;
var jumps = 0;
var canDash = true;
var dashReady = true;
var dashR = false;
var dashL = false;
var levitate = false;
var justWallJumped = false;

@onready var rayCastLeftNode = $RayCastLeft
@onready var rayCastRightNode = $RayCastRight

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		if jumps == 0:
			jumps = 1
		if not levitate:
			velocity.y += gravity * delta
	elif is_on_floor():
		jumps = 0
		justWallJumped = false;
		canDash = true
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		if not justWallJumped and not is_on_floor():
			if rayCastLeftNode.is_colliding() and Input.is_action_pressed("move_left"):
				justWallJumped = true;
				velocity.y = JUMP_VELOCITY
				velocity.x = WALL_PUSH_SPEED
				return
			elif rayCastRightNode.is_colliding() and Input.is_action_pressed("move_right"):
				justWallJumped = true;
				velocity.y = JUMP_VELOCITY
				velocity.x = -WALL_PUSH_SPEED
				return
		if jumps < max_jumps:
			velocity.y = JUMP_VELOCITY
			jumps += 1
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
#	var direction = Input.get_axis("move_left", "move_right")
#	if direction:
#		velocity.x = direction * SPEED
#	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)
	var direction = Input.get_axis("move_left", "move_right") * SPEED
	velocity.x = move_toward(velocity.x, direction, ACCELERATION_SPEED * delta)
	
	if Input.is_action_just_pressed("move_left"):
		if dashL:
			velocity.x = -DASH_SPEED
			doDash()
		elif canDash and dashReady:
			dashL = true
			$DashTimer.start()
	elif Input.is_action_just_pressed("move_right"):
		if dashR:
			velocity.x = DASH_SPEED
			doDash()
		elif canDash and dashReady:
			dashR = true
			$DashTimer.start()
	
	if Input.is_action_just_pressed("dash"):
		if Input.is_action_pressed("move_right"):
			velocity.x = 500
		elif Input.is_action_pressed("move_left"):
			velocity.x = -500

	move_and_slide()

func doDash():
	dashL = false
	canDash = false
	levitate = true
	dashReady = false;
	$DashCooldown.start()
	$LevitateTimer.start()
	velocity.y = 0

func _on_dash_timer_timeout():
	dashL = false
	dashR = false


func _on_levitate_timer_timeout():
	levitate = false


func _on_dash_cooldown_timeout():
	dashReady = true

