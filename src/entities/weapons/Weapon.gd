extends Sprite
class_name Weapon

export (PackedScene) var bullet_reference = preload("res://src/entities/bullets/Bullet.tscn")

func _ready():
	pass

func _process(d):
	if Input.is_action_just_pressed("click"):
		$ShootEffect.pitch_scale = 0.7 + (randf() / 2 - 0.25)
		$ShootEffect.play()
		EventBus.emit_signal("create_bullet", bullet_reference.instance(), $BulletSpawn.global_position, rotation)
		EventBus.emit_signal("start_screenshake", 20)
