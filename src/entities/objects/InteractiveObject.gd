extends RigidBody2D
class_name InteractiveObject

export (String) var message = "Interact"

func _ready():
	pass

func highlight():
	$Interaction.show()
func remove_highligh():
	$Interaction.hide()

func interact():
	EventBus.emit_signal("far_from_interactive_object", self)
	queue_free()

func _on_CollectBox_body_entered(body):
	if body.is_in_group("player"):
		EventBus.emit_signal("close_to_interactive_object", self)
		highlight()

func _on_CollectBox_body_exited(body):
	if body.is_in_group("player"):
		EventBus.emit_signal("far_from_interactive_object", self)
		remove_highligh()
