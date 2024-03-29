extends Node2D

export (PackedScene) var rifle_reference
export (PackedScene) var pistol_reference

onready var player = $YSortable/Entities/Player

func _ready():
	EventBus.connect("create_bullet", self, "add_bullet")
	
	EventBus.connect("close_to_interactive_object", self, "set_new_interaction")
	EventBus.connect("far_from_interactive_object", self, "close_current_interaction")
	
	EventBus.connect("test_throw_weapon", self, "test_throw_weapon")
	
	EventBus.connect("drop_weapon", self, "create_drop_weapon_at")
	
	EventBus.connect("emit_scent", self, "add_scent")
	
	EventBus.connect("got_weapon", self, "display_weapon")
	EventBus.connect("health_changed", self, "health_changed")
	
	EventBus.connect("player_ammo_changed", self, "player_ammo_changed")
	EventBus.connect("give_ammo", self, "give_ammo_to_player")
	
	EventBus.connect("drop_ammo_pickup", self, "spawn_ammo_pickup")
	
	var level_details = LevelProgression.level_difficulty
	
	$LevelGeneration.create_level_with_explosion(level_details.size, level_details.enemies)
	
	for tile in ($LevelGeneration.tiles):
		$Statics.set_cell(tile.x, tile.y, randi()%3 + 1)
	for wall in ($LevelGeneration.walls):
		$YSortable/StaticWalls.set_cell(wall.x, wall.y, 1)
	for outerwall in ($LevelGeneration.outerwalls):
		$YSortable/StaticWalls.set_cell(outerwall.x, outerwall.y, 2)
	
	for enemy in ($LevelGeneration.enemies):
		var new_enemy = preload("res://src/entities/enemies/Enemy.tscn").instance()
		new_enemy.global_position = $Statics.map_to_world(enemy) + Vector2(12, 12)
		$YSortable/Entities.add_child(new_enemy)

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		LevelProgression.go_next_level()
		get_tree().change_scene("res://src/scenes/TestScene.tscn")

func add_bullet(bullet_instance, starting_position, bullet_rotation):
	bullet_instance.global_position = starting_position
	bullet_instance.rotation = bullet_rotation
	bullet_instance.setup()
	$Bullets.add_child(bullet_instance)

func set_new_interaction(obj : InteractiveObject):
	var new_label = Label.new()
	player.current_interactive_obj = obj

func close_current_interaction(obj : InteractiveObject):
	if player.current_interactive_obj == obj:
		player.current_interactive_obj = null

func test_throw_weapon(direction):
	var new_thrown_weapon
	
	if randi()%2 == 0:
		new_thrown_weapon = rifle_reference.instance()
	else:
		new_thrown_weapon = pistol_reference.instance()
	
	new_thrown_weapon.global_position = $YSortable/Entities/Player.global_position
	$YSortable/Entities.add_child(new_thrown_weapon)
	new_thrown_weapon.throw(direction, 420)

func create_drop_weapon_at(weapon_instance, global_pos):
	weapon_instance.global_position = global_pos
	$YSortable/Entities.add_child(weapon_instance)

func add_scent(new_scent):
	$Scents.add_child(new_scent)

func display_weapon(weapon_sprite, slot):
	if slot == 0:
		$UI/Screen/PlayerInfo/Weapons/Slot1.texture = weapon_sprite
	elif slot == 1:
		$UI/Screen/PlayerInfo/Weapons/Slot2.texture = weapon_sprite

func health_changed(max_health, health):
	$UI/Screen/PlayerInfo/HealthBar.max_value = max_health
	$UI/Screen/PlayerInfo/HealthBar.value = health

func give_ammo_to_player(player, ammo_type, ammo_quantity):
	player.give_ammo(ammo_type, ammo_quantity)


func player_ammo_changed(ammo_type, ammo_quantity):
	match ammo_type:
		"bullet":
			$UI/Screen/PlayerInfo/HBoxContainer/BulletCount.text = str(ammo_quantity)
		"shell":
			$UI/Screen/PlayerInfo/HBoxContainer/ShellCount.text = str(ammo_quantity)

func spawn_ammo_pickup(global_pos):
	var new_ammo_pickup = load("res://src/entities/objects/pickups/AmmoPickup.tscn").instance()
	new_ammo_pickup.global_position = global_pos
	yield(get_tree().create_timer(0.01), "timeout")
	$YSortable/Entities.add_child(new_ammo_pickup)
