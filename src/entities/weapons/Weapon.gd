extends Sprite
class_name Weapon

export (String) var id = "gun"

export (PackedScene) var drop_weapon = preload("res://src/entities/objects/InteractiveWeapon.tscn")
export (PackedScene) var bullet_reference = preload("res://src/entities/bullets/Bullet.tscn")

func _ready():
	pass

func _process(d):
	if Input.is_action_just_pressed("click"):
		$ShootEffect.pitch_scale = 0.7 + (randf() / 2 - 0.25)
		$ShootEffect.play()
		EventBus.emit_signal("create_bullet", bullet_reference.instance(), global_position, rotation)
		EventBus.emit_signal("start_screenshake", 10)
	handle_rotatation()


func handle_rotatation():
	# Orients the gun where the mouse is
	look_at(get_global_mouse_position())
	
	# Handle the gun sprite in order not to show it upside down when on the opposite side
	if cos(rotation) > 0:
		flip_v = false
	else:
		flip_v = true
