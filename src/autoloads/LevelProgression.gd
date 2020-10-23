extends Node

var levels = [
	{
		"name": "1-1",
		"size": 120,
		"enemies": 10
	},
	{
		"name": "1-2",
		"size": 180,
		"enemies": 20
	},
	{
		"name": "1-3",
		"size": 200,
		"enemies": 35
	}
]

var difficulty = 1

var level_difficulty = {
	"size": 120,
	"enemies": 10
}

var current_level = 0

func _ready():
	pass # Replace with function body.

func get_level_details():
	return levels[current_level]

func go_next_level():
	difficulty += 1
	level_difficulty.size += 100 * (difficulty)
	level_difficulty.enemies += 8 * (difficulty)
	if current_level < levels.size() - 1:
		current_level += 1
	else:
		current_level = 0
