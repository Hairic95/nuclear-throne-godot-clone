extends Area2D
class_name Bullet

var speed : float = 1000

var direction : Vector2 = Vector2.ZERO

var timer = 0

func _ready():
	$Anim.play("fired")

func _physics_process(delta):
	
	global_position += direction * speed * delta
	
	if timer > 100:
		queue_free()
	else:
		timer += delta
	

func setup():
	direction = Vector2(cos(rotation), sin(rotation))

func _on_Area2D_body_entered(body):
	queue_free()
