extends Weapon

func _ready():
	drop_weapon = load("res://src/entities/objects/dropWeapons/DropRifle.tscn")

func shoot():
	.shoot()
	yield(get_tree().create_timer(.05), "timeout")
	.shoot()
	yield(get_tree().create_timer(.05), "timeout")
	.shoot()
