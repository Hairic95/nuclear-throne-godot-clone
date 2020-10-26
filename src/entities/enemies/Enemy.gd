extends KinematicBody2D
class_name Enemy

export (PackedScene) var bullet_reference 

var is_alive = true

var player_in_range = null

var direction = Vector2.ZERO

var speed = 40

var inner_pushbox = []

var corpse_force = 300

func _ready():
	randomize()

func _process(delta):
	if is_alive:
		# ai to separate from enemy script
		if player_in_range != null:
			$Vision.rotation = PI
			$Vision.cast_to = global_position - player_in_range.global_position
			$Vision.force_raycast_update()
			
			
			var following_player = false
			
			for scent in player_in_range.scent_trail:
				$Vision.cast_to = (global_position - scent.global_position)
				$Vision.force_raycast_update()
				if !$Vision.is_colliding():
					direction = (scent.global_position - global_position).normalized()
					following_player = true
					break
				
			if (player_in_range.global_position - global_position).length() > 100:
				
				if player_in_range.global_position.x > global_position.x:
					$Sprite.flip_h = false
				else:
					$Sprite.flip_h = true
				
				direction = (player_in_range.global_position - global_position).normalized()
				
			else:
				direction = (global_position - player_in_range.global_position).normalized()
				
				if !following_player:
					player_in_range = null
					direction = Vector2.ZERO
					$ShootChanceInterval.stop()
		else:
			$Vision.rotate(delta * PI * 6)
			$Vision.cast_to = Vector2(120, 0)
			$Vision.force_raycast_update()
			if $Vision.is_colliding():
				var collider = $Vision.get_collider()
				if collider.is_in_group("player"):
					player_in_range = collider
					$ShootChanceInterval.start()
		
		# pushbox logic
		var push_force = Vector2.ZERO
		for pushbox in inner_pushbox:
			push_force += (global_position - pushbox.global_position).normalized() * 20
		
		move_and_slide(direction * speed + push_force)
		
		if direction != Vector2.ZERO:
			 $AnimTree.set("parameters/tr_movement/current", 1)
		else:
			 $AnimTree.set("parameters/tr_movement/current", 0)
	else:
		
		if corpse_force > 0:
			var collision = move_and_collide(direction * corpse_force * delta)
			
			if collision:
				direction = direction.bounce(collision.normal)
			
			corpse_force = max(0, corpse_force - 8)
			
			if corpse_force == 0:
				$Hitbox.remove_from_group("player_bullet")
			

var health = 4

func take_damage(damage, bullet_dir):
	health = max(0, health - damage)
	if health > 0:
		$AnimTree.set("parameters/os_hurt/active", true)
	else:
		$AnimTree.set("parameters/tr_alive/current", 1)
		$ShootChanceInterval.stop()
		$Hitbox.remove_from_group("enemy_hitbox")
		$Hitbox.add_to_group("player_bullet")
		is_alive = false
		direction = bullet_dir

func _on_Hitbox_area_entered(area):
	if is_alive:
		if area.is_in_group("player_bullet"):
			take_damage(1, area.get_parent().direction)
	else:
		if area.is_in_group("enemy_hitbox"):
			direction = direction.bounce((area.global_position - global_position).normalized())

func _on_ShootChanceInterval_timeout():
	if randi() % 5 == 0:
		shoot()

func shoot():
	EventBus.emit_signal("create_bullet", 
			bullet_reference.instance(), 
			global_position, 
			$Vision.cast_to.normalized().angle() + PI)


func _on_PushBox_area_entered(area):
	if area.is_in_group("pushbox"):
		inner_pushbox.append(area)


func _on_PushBox_area_exited(area):
	if inner_pushbox.has(area):
		inner_pushbox.erase(area)
