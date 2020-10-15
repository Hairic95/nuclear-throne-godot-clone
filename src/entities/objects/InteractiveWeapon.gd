extends InteractiveObject
class_name InteractiveWeapon

export (PackedScene) var weapon_at_pickup = load("res://src/entities/weapons/Weapon.tscn")

func _ready():
	pass # Replace with function body.

func throw(direction, force):
	apply_central_impulse(direction * force)

func set_image(texture : Texture):
	$Sprite.texture = texture
