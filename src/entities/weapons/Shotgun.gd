extends Weapon

func _ready():
	drop_weapon = load("res://src/entities/objects/dropWeapons/DropShotgun.tscn")

func shoot():
	
	$ShootEffect.pitch_scale = 0.7 + (randf() / 2 - 0.25)
	$ShootEffect.play()
	for i in range(3):
		EventBus.emit_signal("create_bullet", bullet_reference.instance(), global_position, rotation + randf() / 12)
		EventBus.emit_signal("create_bullet", bullet_reference.instance(), global_position, rotation - randf() / 12)
		
		yield(get_tree().create_timer(.02), "timeout")
	EventBus.emit_signal("consume_ammo", 1, ammo_type)
	EventBus.emit_signal("start_screenshake", 10)
	
