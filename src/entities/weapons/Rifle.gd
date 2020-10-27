extends Weapon

func _ready():
	drop_weapon = load("res://src/entities/objects/dropWeapons/DropRifle.tscn")

func shoot():
	.shoot()
	EventBus.emit_signal("consume_ammo", 1, ammo_type)
	yield(get_tree().create_timer(.05), "timeout")
	.shoot()
	EventBus.emit_signal("consume_ammo", 1, ammo_type)
	yield(get_tree().create_timer(.05), "timeout")
	.shoot()
	EventBus.emit_signal("consume_ammo", 1, ammo_type)
