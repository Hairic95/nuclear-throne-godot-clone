extends Area2D
class_name Bullet

var speed : float = 800

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
	
	if $Direction.is_colliding():
		# TODO Change to a destroy animation
		$Sprite.hide()
	

func setup():
	direction = Vector2(cos(rotation), sin(rotation))

func _on_Area2D_body_entered(body):
	queue_free()
