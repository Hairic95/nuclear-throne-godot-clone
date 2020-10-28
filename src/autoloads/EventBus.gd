extends Node

signal close_to_interactive_object(obj)
signal far_from_interactive_object(obj)

signal create_bullet(bullet_instance, starting_position, rotation)

signal start_screenshake(force)

signal drop_weapon(drop_weapon_instance, position)

signal emit_scent(new_scent)

signal give_ammo(player, ammo_type, ammo_quantity)
signal player_ammo_changed(ammo_type, ammo_quantity)
signal consume_ammo(ammo_consumed, ammo_type)

# Player UI

signal got_weapon(weapon_sprite, slot)
signal health_changed(max_health, current_health)

signal no_ammo_display(ammo_type)

# test

signal test_throw_weapon(direction)
