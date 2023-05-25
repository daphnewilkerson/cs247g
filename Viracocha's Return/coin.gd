extends Area2D
class_name Coin


func _on_body_entered(body):
	queue_free()
