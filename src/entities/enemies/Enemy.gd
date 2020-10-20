extends KinematicBody2D
class_name Enemy

export (PackedScene) var bullet_reference 

var is_alive = true

var player_in_range = null

var speed = 100

func _ready():
	randomize()

func _process(delta):
	if is_alive:
		if player_in_range != null:
			$Vision.cast_to = global_position - player_in_range.global_position
			$Vision.force_raycast_update()
			if !$Vision.is_colliding():
				
				if player_in_range.global_position.x > global_position.x:
					$Sprite.flip_h = false
				else:
					$Sprite.flip_h = true
				
				move_and_collide((player_in_range.global_position - global_position).normalized() * speed * delta)
			
			$Vision.look_at(player_in_range.global_position)
		else:
			$Vision.rotate(delta * PI * 4)
			$Vision.cast_to = Vector2(120, 0)
			$Vision.force_raycast_update()
			if $Vision.is_colliding():
				var collider = $Vision.get_collider()
				if collider.is_in_group("player"):
					player_in_range = collider
					$ShootChanceInterval.start()

var health = 4

func take_damage(damage):
	print("dude")
	health = max(0, health - damage)
	if health > 0:
		$AnimTree.set("parameters/os_hurt/active", true)
	else:
		$AnimTree.set("parameters/tr_alive/current", 1)
		$ShootChanceInterval.stop()
		$Hitbox.queue_free()
		$Collision.queue_free()
		is_alive = false

func _on_Hitbox_area_entered(area):
	if is_alive:
		if area.is_in_group("player_bullet"):
			take_damage(1)


func _on_ShootChanceInterval_timeout():
	if randi() % 5 == 0:
		shoot()

func shoot():
	EventBus.emit_signal("create_bullet", bullet_reference.instance(), global_position, $Vision.rotation)
