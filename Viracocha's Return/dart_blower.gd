extends CharacterBody2D
class_name DartBlower

var speed = 50
var patrol_dist = 20
var direction = Vector2.LEFT
var dist_traveled = 0

var Dart = preload("res://flower_dart.tscn")

@onready var player = get_tree().get_nodes_in_group("player")[0]
@onready var _animated_sprite = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	
func shoot():
	var d = Dart.instantiate()
	var dir = (player.global_position - global_position).normalized()
	var pos = $Mouth.global_position
	var dartDir = Vector2.LEFT
	if dir.x > 0: 
		pos = $Mouth2.global_position
		dartDir = Vector2.RIGHT
	
	var angle = dartDir.angle()

	d.start(pos, angle, dartDir)
	get_tree().root.add_child(d)
	
func switchDir():
	direction = -direction
	dist_traveled = 0
	_animated_sprite.flip_h = not _animated_sprite.flip_h


func _physics_process(delta):
	_animated_sprite.play("walking")
	var collision = move_and_collide(direction * speed * delta)
	if collision:
		var collider = collision.get_collider()
		if collider is PlayerBody:
			player.global_position = player.lastCheckpoint
		switchDir()
	
	dist_traveled += abs(velocity.x)
	if dist_traveled >= patrol_dist:
		switchDir()


func _on_shoot_timer_timeout():
	shoot()
