extends Pickup

func _ready():
	randomize()

func on_pickup():
	if player != null:
		var ammo_type = roll_ammo_type()
		EventBus.emit_signal("give_ammo", player, ammo_type, Globals.ammo_quantities[ammo_type])

func roll_ammo_type():
	var chance = randf()
	
	var player_ammo_type = []
	
	for weapon in player.weapons:
		player_ammo_type.append(weapon.ammo_type)
	
	if chance >= 0.1:
		return player_ammo_type[randi()%player_ammo_type.size()]
	else:
		return Globals.ammo_quantities.keys()[randi()%Globals.ammo_quantities.size()]
