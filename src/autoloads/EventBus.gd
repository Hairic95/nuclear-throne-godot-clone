extends Node

signal close_to_interactive_object(obj)
signal far_from_interactive_object(obj)

signal create_bullet(bullet_instance, starting_position, rotation)

signal start_screenshake(force)

signal drop_weapon(drop_weapon_instance, position)

signal emit_scent(new_scent)

# Player UI

signal got_weapon(weapon_sprite, slot)
signal health_changed(max_health, current_health)

# test

signal test_throw_weapon(direction)
