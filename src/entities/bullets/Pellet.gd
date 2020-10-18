extends KinematicBody2D

var direction : Vector2 = Vector2.ZERO

export (String, "enemy_hitbox", "player_hitbox") var target_hitbox = "enemy_hitbox"

export (float) var speed = 800

func _physics_process(delta):
	
	speed = lerp(speed, 0, 0.1)
	
	var collision = move_and_collide(direction * speed  * delta)
	
	if speed <= 25:
		queue_free()
	
	if collision:
		speed = max(0, speed - 50)
		direction = direction.bounce(collision.normal)
		rotation = direction.angle()

func setup():
	direction = Vector2(cos(rotation), sin(rotation))


func _on_Hitbox_area_entered(area):
	if area.is_in_group(target_hitbox):
		queue_free()
