extends CharacterBody2D
class_name Flower

var Dart = preload("res://flower_dart.tscn")

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var player = get_tree().get_nodes_in_group("player")[0]

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func shoot():
	var d = Dart.instantiate()
	var pos = $Muzzle.global_position
	var dir = (player.global_position - $Muzzle.global_position).normalized()
	var angle = dir.angle()
#	d.direction = dir
	d.start(pos, angle, dir)
	get_tree().root.add_child(d)

func _on_shoot_timer_timeout():
	shoot()
