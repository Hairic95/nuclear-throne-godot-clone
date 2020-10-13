extends Node2D

func _ready():
	EventBus.connect("create_bullet", self, "add_bullet")
	
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
	$YSortable/Bullets.add_child(bullet_instance)
