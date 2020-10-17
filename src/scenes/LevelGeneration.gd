extends Node

const directions = [
	Vector2.UP,
	Vector2.DOWN,
	Vector2.RIGHT,
	Vector2.LEFT
]

var tiles = []
var walls = []
var outerwalls = []

var enemies = []

func _ready():
	randomize()

func create_level():
	
	var iteration = 0
	var maxIteration = 700
	
	var walkers : Array = []
	for i in range(5):
		walkers.append(GenerationWalker.new(
					Vector2.ZERO, 
					directions[randi()%directions.size()]))
	
	var max_tiles = 400
	
	while(iteration < maxIteration && max_tiles > tiles.size()):
		
		for walker in walkers:
			if (!tiles.has(walker.position)):
				tiles.append(walker.position)
			if (!tiles.has(walker.position + Vector2.UP)):
				tiles.append(walker.position + Vector2.UP)
			if (!tiles.has(walker.position + Vector2.LEFT)):
				tiles.append(walker.position + Vector2.LEFT)
			if (!tiles.has(walker.position + Vector2(-1, -1))):
				tiles.append(walker.position + Vector2(-1, -1))
			
			walker.position += walker.direction
			if randi() % 3 == 0:
				walker.direction = directions[randi()%directions.size()]
		
		iteration += 1
	
	for tile in tiles:
		if !(tiles.has(tile + Vector2.UP)):
			walls.append(tile + Vector2.UP)
		if !(tiles.has(tile + Vector2.DOWN)):
			walls.append(tile + Vector2.DOWN)
		if !(tiles.has(tile + Vector2.LEFT)):
			walls.append(tile + Vector2.LEFT)
		if !(tiles.has(tile + Vector2.RIGHT)):
			walls.append(tile + Vector2.RIGHT)
	
	for wall in walls:
		if !walls.has(wall + Vector2.DOWN) && !tiles.has(wall + Vector2.DOWN):
			outerwalls.append(wall + Vector2.DOWN)

func create_level_with_explosion():
	
	var iteration = 0
	var maxIteration = 700
	
	var walkers : Array = []
	for i in range(5):
		walkers.append(GenerationWalker.new(
					Vector2.ZERO, 
					directions[randi()%directions.size()]))
	
	var max_tiles = 800
	var explosions = 9
	
	while(iteration < maxIteration && max_tiles > tiles.size()):
		
		for walker in walkers:
			if (!tiles.has(walker.position)):
				tiles.append(walker.position)
			if (!tiles.has(walker.position + Vector2.UP)):
				tiles.append(walker.position + Vector2.UP)
			if (!tiles.has(walker.position + Vector2.LEFT)):
				tiles.append(walker.position + Vector2.LEFT)
			if (!tiles.has(walker.position + Vector2(-1, -1))):
				tiles.append(walker.position + Vector2(-1, -1))
			
			walker.position += walker.direction
			if randi() % 3 == 0:
				walker.direction = directions[randi()%directions.size()]
			
	for ex in range(explosions):
		
		var starting_tile = tiles[randi()%tiles.size()]
		
		for x in range (randi()%4 + 4):
			for y in range (randi()%4 + 4):
				if (!tiles.has(starting_tile + Vector2(x, y))):
					tiles.append(starting_tile + Vector2(x, y))
		
		iteration += 1
	
	for tile in tiles:
		if !(tiles.has(tile + Vector2.UP)):
			walls.append(tile + Vector2.UP)
		if !(tiles.has(tile + Vector2.DOWN)):
			walls.append(tile + Vector2.DOWN)
		if !(tiles.has(tile + Vector2.LEFT)):
			walls.append(tile + Vector2.LEFT)
		if !(tiles.has(tile + Vector2.RIGHT)):
			walls.append(tile + Vector2.RIGHT)
		if !(tiles.has(tile + Vector2.UP + Vector2.LEFT)):
			walls.append(tile + Vector2.UP + Vector2.LEFT)
		if !(tiles.has(tile + Vector2.DOWN + Vector2.LEFT)):
			walls.append(tile + Vector2.DOWN + Vector2.LEFT)
		if !(tiles.has(tile + Vector2.UP + Vector2.RIGHT)):
			walls.append(tile + Vector2.UP + Vector2.RIGHT)
		if !(tiles.has(tile + Vector2.DOWN + Vector2.RIGHT)):
			walls.append(tile + Vector2.DOWN + Vector2.RIGHT)
		
		if randi()% 20 == 0:
			enemies.append(tile)
		
	
	for wall in walls:
		if !walls.has(wall + Vector2.DOWN) && !tiles.has(wall + Vector2.DOWN):
			outerwalls.append(wall + Vector2.DOWN)

class GenerationWalker:
	var position : Vector2
	var direction : Vector2
	
	func _init(starting_position, starting_direction):
		position = starting_position
		direction = starting_direction
