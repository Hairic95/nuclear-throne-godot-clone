extends Weapon


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func shoot():
	$ShootEffect.pitch_scale = 0.7 + (randf() / 2 - 0.25)
	var starting_rotation = rotation
	$ShootEffect.play()
	EventBus.emit_signal("create_bullet", bullet_reference.instance(), global_position, starting_rotation)
	EventBus.emit_signal("start_screenshake", 4)
	yield(get_tree().create_timer(.09), "timeout")
	EventBus.emit_signal("create_bullet", bullet_reference.instance(), global_position, starting_rotation)
	EventBus.emit_signal("start_screenshake", 6)
	yield(get_tree().create_timer(.03), "timeout")
	EventBus.emit_signal("create_bullet", bullet_reference.instance(), global_position, starting_rotation)
	EventBus.emit_signal("start_screenshake", 8)
