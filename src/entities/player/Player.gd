extends KinematicBody2D

const SPEED : float = 150.0

export (PackedScene) var bullet_reference = preload("res://src/entities/bullets/Bullet.tscn")
export (PackedScene) var scent_reference = preload("res://src/entities/player/components/Scent.tscn")

var is_alive : bool = true

var direction_input : Vector2 = Vector2.ZERO

var current_interactive_obj : InteractiveObject = null

var current_weapon = null

var max_weapon_slot = 2

var health = 4

var scent_trail = []

func _ready():
	$AnimTree.active = true

func _process(delta):
	
	if is_alive:
			
		if Input.is_key_pressed(KEY_W):
			direction_input.y = -1
		if Input.is_key_pressed(KEY_S):
			direction_input.y = 1
		if Input.is_key_pressed(KEY_A):
			direction_input.x = -1
		if Input.is_key_pressed(KEY_D):
			direction_input.x = 1
		
		if get_global_mouse_position().x < global_position.x:
			$Sprite.flip_h = true
		if get_global_mouse_position().x > global_position.x:
			$Sprite.flip_h = false
		
		if Input.is_action_just_pressed("interact") and current_interactive_obj != null:
			if current_interactive_obj is InteractiveWeapon:
				add_weapon(current_interactive_obj.weapon_at_pickup)
				current_interactive_obj.interact()
		if Input.is_action_just_pressed("ability"):
			EventBus.emit_signal("test_throw_weapon", Vector2(get_global_mouse_position() - global_position).normalized())
		
		if Input.is_action_just_pressed("next_weapon"):
			next_weapon()
		
		if direction_input != Vector2.ZERO:
			 $AnimTree.set("parameters/tr_movement/current", 1)
		else:
			 $AnimTree.set("parameters/tr_movement/current", 0)
		
		handle_camera_position()
	
	move_and_slide(direction_input.normalized() * SPEED)
	
	direction_input = Vector2.ZERO

func add_weapon(new_weapon_reference):
	var new_weapon = new_weapon_reference.instance()
	if $Weapons.get_child_count() >= max_weapon_slot:
		drop_current_weapon()
	$Weapons.add_child(new_weapon)
	set_current_weapon(new_weapon)

func next_weapon():
	
	for weapon_index in range($Weapons.get_child_count()):
		if $Weapons.get_child(weapon_index).active:
			if $Weapons.get_child_count() - 1 == weapon_index:
				set_current_weapon($Weapons.get_child(0))
			else:
				set_current_weapon($Weapons.get_child(weapon_index + 1))
			break

func set_current_weapon(new_current_weapon):
	
	for weapon in $Weapons.get_children():
		weapon.set_active(false)
	
	new_current_weapon.set_active(true)
	current_weapon = new_current_weapon
	new_current_weapon.handle_rotatation()

func drop_current_weapon():
	var new_interactive_weapon = current_weapon.drop_weapon.instance()
	EventBus.emit_signal("drop_weapon", new_interactive_weapon, global_position)
	
	current_weapon.queue_free()
	current_weapon = null

func handle_camera_position():
	var new_camera_position = global_position + (get_global_mouse_position() - global_position) / 3
	$CameraHandler.global_position = new_camera_position


func _on_Hitbox_area_entered(area):
	if area.is_in_group("enemy_bullet"):
		take_damage(1)

func take_damage(damage):
	health = max(0, health - damage)
	if health <= 0:
		$AnimTree.set("parameters/tr_alive/current", 1)
		is_alive = false
		
	else:
		$AnimTree.set("parameters/os_hurt/active", true)

func emit_scent():
	var new_scent = scent_reference.instance()
	new_scent.global_position = global_position
	if scent_trail.size() > 20:
		var oldest_scent = scent_trail.pop_front()
		oldest_scent.queue_free()
	scent_trail.append(new_scent)
	EventBus.emit_signal("emit_scent", new_scent)

func _on_ScentTimer_timeout():
	emit_scent()
