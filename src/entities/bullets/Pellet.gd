extends KinematicBody2D

var direction : Vector2 = Vector2.ZERO

export (float) var speed = 200

func _physics_process(delta):
	
	speed = lerp(speed, 0, 0.1)
	
	var collision = move_and_collide(direction * speed  * delta)
	
	if speed <= 25:
		queue_free()
	
	if collision:
		direction = direction.bounce(collision.normal)
		rotation = direction.angle()

func setup():
	direction = Vector2(cos(rotation), sin(rotation))

