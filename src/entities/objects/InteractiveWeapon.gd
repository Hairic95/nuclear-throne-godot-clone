extends InteractiveObject
class_name InteractiveWeapon

export (PackedScene) var weapon_at_pickup = load("res://src/entities/weapons/Weapon.tscn")

export (String, "bullet", "shell") var ammo_type

onready var remaining_bullets = 2 * Globals.ammo_quantities[ammo_type]

func _ready():
	pass # Replace with function body.

func throw(direction, force):
	apply_central_impulse(direction * force)

func set_image(texture : Texture):
	$Sprite.texture = texture

func _on_CollectBox_body_entered(body):
	._on_CollectBox_body_entered(body)
	if body.is_in_group("player"):
		EventBus.emit_signal("give_ammo", body, ammo_type, remaining_bullets)
		remaining_bullets = 0
