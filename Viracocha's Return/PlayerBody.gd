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
var ropeGrabbed = false;
var ropeReleased = false;
var canGrab = true;
var ropePart = null;
var lastCheckpoint : Vector2 = Vector2.ZERO;

@onready var rayCastLeftNode = $RayCastLeft
@onready var rayCastRightNode = $RayCastRight
@onready var animationTree = $AnimationTree
@onready var state_machine = animationTree["parameters/playback"]

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	animationTree.active = true;
	state_machine.start("idle");
	lastCheckpoint = global_position;
	
func _process(delta):
	
	update_animation_parameters();

func _physics_process(delta):
	ropeReleased = false;
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is Dart:
			get_tree().reload_current_scene()

	
	if ropeGrabbed:
		global_position = ropePart.global_position
		if Input.is_action_just_pressed("jump"):
			ropeGrabbed = false;
			ropePart = null;
			$RopeCooldown.start();
			ropeReleased = true;
	
	
	
	# Add the gravity.
	if not is_on_floor() and not ropeGrabbed:
		if jumps == 0:
			jumps = 1
		if not levitate:
			velocity.y += gravity * delta
	elif is_on_floor():
		jumps = 0
		justWallJumped = false;
		canDash = true
		
	if ropeReleased:
		jumps = 0;
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		if not justWallJumped and not is_on_floor():
			if rayCastLeftNode.is_colliding() and Input.is_action_pressed("move_left"):
				justWallJumped = true;
				velocity.y = JUMP_VELOCITY
				velocity.x = WALL_PUSH_SPEED
				state_machine.travel("jumping")
				return
			elif rayCastRightNode.is_colliding() and Input.is_action_pressed("move_right"):
				justWallJumped = true;
				velocity.y = JUMP_VELOCITY
				velocity.x = -WALL_PUSH_SPEED
				state_machine.travel("jumping")
				return
		if jumps < max_jumps:
			velocity.y = JUMP_VELOCITY
			jumps += 1
			if jumps == 1:
				state_machine.travel("jumping")
			else:
				state_machine.travel("double_jumping")
	
	if (rayCastLeftNode.is_colliding() and Input.is_action_pressed("move_left")) or (rayCastRightNode.is_colliding() and Input.is_action_pressed("move_right")):
		if velocity.y > 50:
			velocity.y = 50;

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
		$Sprite2D.flip_h = true;
		if dashL:
			velocity.x = -DASH_SPEED
			doDash()
		elif canDash and dashReady:
			dashL = true
			$DashTimer.start()
	elif Input.is_action_just_pressed("move_right"):
		$Sprite2D.flip_h = false;
		if dashR:
			velocity.x = DASH_SPEED
			doDash()
		elif canDash and dashReady:
			dashR = true
			$DashTimer.start()
	
	if Input.is_action_just_pressed("dash") and canDash:
		if Input.is_action_pressed("move_right"):
			velocity.x = DASH_SPEED
			doDash()
		elif Input.is_action_pressed("move_left"):
			velocity.x = -DASH_SPEED
			doDash()

	move_and_slide()

func doDash():
	dashL = false;
	dashR = false;
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



func _on_grab_zone_area_entered(area):
	if area.is_in_group("rope") and canGrab:
		ropeGrabbed = true;
		canGrab = false;
		ropePart = area;


func _on_rope_cooldown_timeout():
	canGrab = true;
	
#
func update_animation_parameters():
	if velocity == Vector2.ZERO:
		state_machine.travel("idle")
	elif is_on_floor():
		state_machine.travel("running")


func _on_hitbox_area_entered(area):
	if area is Fire:
		global_position = lastCheckpoint;
	if area is Coin:
		lastCheckpoint = global_position
