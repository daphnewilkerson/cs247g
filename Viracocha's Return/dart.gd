extends CharacterBody2D
class_name Dart

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: Vector2 = Vector2.LEFT

func start(pos, angle, dir):
	global_position = pos
	global_rotation = angle
	direction = dir

func _physics_process(delta):
	var collision = move_and_collide(direction * SPEED * delta)
	if collision:
		var collider = collision.get_collider()
		if collider is PlayerBody:
			get_tree().reload_current_scene()
		if collider is Flower:
			return
		queue_free()
