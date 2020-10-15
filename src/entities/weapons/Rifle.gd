extends Weapon


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func shoot():
	.shoot()
	yield(get_tree().create_timer(.09), "timeout")
	.shoot()
	yield(get_tree().create_timer(.09), "timeout")
	.shoot()
