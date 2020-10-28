extends KinematicBody2D
class_name Pickup

var player = null

var speed = 150

func _ready():
	$Anim.play("idle")

func _process(delta):
	
	if player:
		move_and_slide(speed * (player.global_position - global_position).normalized())
	

func _on_PickupArea_body_entered(body):
	if body.is_in_group("player"):
		player = body
		on_pickup()
		queue_free()

func on_pickup():
	pass

func _on_StartFadingOut_timeout():
	$Anim.play("fading")

func _on_Erase_timeout():
	queue_free()


func _on_DetectPlayer_body_entered(body):
	if body.is_in_group("player"):
		player = body
