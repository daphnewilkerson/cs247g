extends CharacterBody2D
class_name DartBlower

var speed = 50
var patrol_dist = 20
var direction = Vector2.LEFT
var dist_traveled = 0

@onready var player = get_tree().get_nodes_in_group("player")[0]

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	
func _physics_process(delta):
	var collision = move_and_collide(direction * speed * delta)
	if collision:
		var collider = collision.get_collider()
		if collider is PlayerBody:
			player.global_position = player.lastCheckpoint
		direction = -direction
		dist_traveled = 0
	
	dist_traveled += abs(velocity.x)
	if dist_traveled >= patrol_dist:
		direction = -direction
		dist_traveled = 0
