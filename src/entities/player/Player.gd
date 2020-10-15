extends KinematicBody2D

const SPEED : float = 150.0

export (PackedScene) var bullet_reference = preload("res://src/entities/bullets/Bullet.tscn")

var is_alive : bool = true
var is_moving_by_player : bool = false

var direction_input : Vector2 = Vector2.ZERO

var current_interactive_obj : InteractiveObject = null

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
		
		
		if Input.is_key_pressed(KEY_H):
			$AnimTree.set("parameters/os_hurt/active", true)
		
		if Input.is_key_pressed(KEY_K):
			$AnimTree.set("parameters/tr_alive/current", 1)
			is_alive = false
		
		if Input.is_action_just_pressed("interact") and current_interactive_obj != null:
			if current_interactive_obj is InteractiveWeapon:
				add_weapon(current_interactive_obj.weapon_at_pickup)
				current_interactive_obj.interact()
		if Input.is_action_just_pressed("ability"):
			EventBus.emit_signal("test_throw_weapon", Vector2(get_global_mouse_position() - global_position).normalized())
		
		if Input.is_key_pressed(KEY_W) || Input.is_key_pressed(KEY_S) || Input.is_key_pressed(KEY_A) || Input.is_key_pressed(KEY_D):
			is_moving_by_player = true
		
		if is_moving_by_player and direction_input != Vector2.ZERO:
			 $AnimTree.set("parameters/tr_movement/current", 1)
		else:
			 $AnimTree.set("parameters/tr_movement/current", 0)
		
		handle_camera_position()
	
	move_and_slide(direction_input.normalized() * SPEED)
	
	direction_input = Vector2.ZERO
	is_moving_by_player = false

func add_weapon(new_weapon_reference):
	
	var new_weapon = new_weapon_reference.instance()
	new_weapon.set_active(true)
	new_weapon.handle_rotatation()
	
	for weapon in $Weapons.get_children():
		weapon.set_active(false)
	
	$Weapons.add_child(new_weapon)


func handle_camera_position():
	var new_camera_position = global_position + (get_global_mouse_position() - global_position) / 3
	$CameraHandler.global_position = new_camera_position
