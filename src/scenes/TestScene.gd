extends Node2D

onready var player = $YSortable/Entities/Player

func _ready():
	EventBus.connect("create_bullet", self, "add_bullet")
	
	EventBus.connect("close_to_interactive_object", self, "set_new_interaction")
	EventBus.connect("far_from_interactive_object", self, "close_current_interaction")
	
	EventBus.connect("test_throw_weapon", self, "test_throw_weapon")
	
	$LevelGeneration.create_level_with_explosion()
	
	for tile in ($LevelGeneration.tiles):
		$Statics/TileMap.set_cell(tile.x, tile.y, 0)
	for wall in ($LevelGeneration.walls):
		$YSortable/StaticsWalls/TileMap.set_cell(wall.x, wall.y, 1)
	for outerwall in ($LevelGeneration.outerwalls):
		$YSortable/StaticsWalls/TileMap.set_cell(outerwall.x, outerwall.y, 2)

func add_bullet(bullet_instance, starting_position, bullet_rotation):
	bullet_instance.global_position = starting_position
	bullet_instance.rotation = bullet_rotation
	bullet_instance.setup()
	$Bullets.add_child(bullet_instance)

func set_new_interaction(obj : InteractiveObject):
	var new_label = Label.new()
	new_label.text = obj.message
	new_label.rect_global_position = obj.global_position
	$Popup.add_child(new_label)
	player.current_interactive_obj = obj
	$UI/Control/Label.text = obj.message

func close_current_interaction(obj : InteractiveObject):
	if player.current_interactive_obj == obj:
		player.current_interactive_obj = null
		$UI/Control/Label.text = ""

func test_throw_weapon(direction):
	var new_thrown_weapon = load("res://src/entities/objects/InteractiveWeapon.tscn").instance()
	new_thrown_weapon.global_position = $YSortable/Entities/Player.global_position
	$YSortable/Entities.add_child(new_thrown_weapon)
	new_thrown_weapon.throw(direction, 420)
