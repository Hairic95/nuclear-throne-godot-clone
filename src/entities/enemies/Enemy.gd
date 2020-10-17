extends KinematicBody2D
class_name Enemy

var is_alive = true

func _ready():
	pass

var health = 4

func take_damage(damage):
	print("dude")
	health = max(0, health - damage)
	if health > 0:
		$AnimTree.set("parameters/os_hurt/active", true)
	else:
		$AnimTree.set("parameters/tr_alive/current", 1)
		$Hitbox.queue_free()
		$Collision.queue_free()
		is_alive = false

func _on_Hitbox_area_entered(area):
	if is_alive:
		if area.is_in_group("bullet"):
			take_damage(1)
