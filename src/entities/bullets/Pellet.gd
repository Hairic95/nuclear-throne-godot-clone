extends Area2D

var direction : Vector2 = Vector2.ZERO

export (float) var speed = 200

func _physics_process(delta):
	global_position += direction * speed  * delta
	
	#speed = lerp(speed, 0, 0.05)
	
	if speed <= 15:
		queue_free()
	
	if $Direction.is_colliding():
		if !$Direction.get_collider().is_in_group("player"):
			if $Direction.get_collision_normal() != Vector2.ZERO:
				direction = direction.bounce($Direction.get_collision_normal().normalized())
				rotation = direction.angle()
			else:
				
				direction = (global_position - $Direction.get_collision_point()).normalized()
				rotation = direction.angle()

func setup():
	direction = Vector2(cos(rotation), sin(rotation))

