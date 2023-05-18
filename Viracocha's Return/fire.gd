extends Area2D



func _on_body_entered(body):
	if body is PlayerBody:
		get_tree().reload_current_scene()
