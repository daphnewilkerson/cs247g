extends Area2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
var hasSpoken= false
#has boolean of has_spoken, you just return

		

func speech () -> void:
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
	hasSpoken = true

func _on_body_entered(body):
	speech() # Replace with function body.
