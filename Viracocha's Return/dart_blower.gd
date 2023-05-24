extends CharacterBody2D
class_name DartBlower
var Dart = preload("res://flower_dart.tscn")

const SPEED = -20.0
const JUMP_VELOCITY = -400.0

@onready var player = get_tree().get_nodes_in_group("player")[0]

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func shoot():
	var d = Dart.instantiate()
	d.global_position = $Mouth.global_position
	var dir = (player.global_position - $Mouth.global_position).normalized()
	d.global_rotation = dir.angle()
	d.direction = dir
	get_tree().root.add_child(d)

func _physics_process(delta):
	pass
#	velocity.x = SPEED
#
#	# Add the gravity.
#	if not is_on_floor():
#		velocity.y += gravity * delta
#
#	var collision = move_and_collide(velocity * delta)
#	if collision:
#		velocity = velocity.bounce(collision.get_normal())
#		var collider = collision.get_collider()
#		if collider is CharacterBody2D:
#			print('player hit')



func _on_shoot_timer_timeout():
	shoot()
