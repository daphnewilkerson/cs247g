extends CharacterBody2D


const SPEED = -30.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	
	velocity.x = SPEED
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		var collider = collision.get_collider()
		if collider is CharacterBody2D:
			print('player hit')

			
		
