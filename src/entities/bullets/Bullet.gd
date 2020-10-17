extends KinematicBody2D
class_name Bullet

var speed : float = 800

var direction : Vector2 = Vector2.ZERO

var timer = 0

func _ready():
	$Anim.play("fired")

func _physics_process(delta):
	
	var collision = move_and_collide(direction * speed * delta)
	
	if collision:
		queue_free()
	

func setup():
	direction = Vector2(cos(rotation), sin(rotation))

func _on_Hitbox_area_entered(area):
	if area.is_in_group("enemy_hitbox"):
		queue_free()
