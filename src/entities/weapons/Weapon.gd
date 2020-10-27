extends Sprite
class_name Weapon

export (String) var id = "gun"

export (bool) var is_automatic = false

export (float) var reload_time = 0.2

export (PackedScene) var drop_weapon 
export (PackedScene) var bullet_reference = load("res://src/entities/bullets/Bullet.tscn")

export (String, "bullet", "shell") var ammo_type = "bullet"
export (int) var ammo_per_shoot = 1

var active : bool = false

var has_ammo : bool = false

var is_reloading = false

func _ready():
	$Reloading.wait_time = reload_time

func _process(d):
	if active:
		if has_ammo:
			if is_automatic:
				if Input.is_action_pressed("click") and !is_reloading:
					shoot()
					is_reloading = true
					$Reloading.start()
			else:
				if Input.is_action_just_pressed("click") and !is_reloading:
					shoot()
					is_reloading = true
					$Reloading.start()
		else:
			EventBus.emit_signal("no_ammo_display", ammo_type)
	handle_rotatation()


func handle_rotatation():
	# Orients the gun where the mouse is
	if get_global_mouse_position() != null:
		look_at(get_global_mouse_position())
	
	# Handle the gun sprite in order not to show it upside down when on the opposite side
	if cos(rotation) > 0:
		flip_v = false
	else:
		flip_v = true

func set_active(value):
	active = value
	visible = value

func shoot():
	$ShootEffect.pitch_scale = 0.7 + (randf() / 2 - 0.25)
	$ShootEffect.play()
	EventBus.emit_signal("create_bullet", bullet_reference.instance(), global_position, rotation)
	EventBus.emit_signal("start_screenshake", 10)


func _on_Reloading_timeout():
	is_reloading = false
