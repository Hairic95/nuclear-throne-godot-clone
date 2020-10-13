extends Area2D
class_name InteractiveObject

export (String) var message = "Interact"

func _ready():
	pass

func _on_InteractiveObject_body_entered(body):
	if body.is_in_group("player"):
		EventBus.emit_signal("close_to_interactive_object", self)


func _on_InteractiveObject_body_exited(body):
	if body.is_in_group("player"):
		EventBus.emit_signal("far_from_interactive_object", self)

func interact():
	EventBus.emit_signal("far_from_interactive_object", self)
	queue_free()
