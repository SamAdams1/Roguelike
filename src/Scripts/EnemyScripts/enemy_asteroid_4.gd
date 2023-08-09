extends "res://Scripts/EnemyScripts/enemy_core.gd"
onready var hands = $Sprite/Hands
onready var enemyStopped = $Sprite/enemyStopped


var is_in_void = false
var retreat = false
var stun = false

func _process(delta):
	if stun == false:
		if is_in_void == false and retreat == false:
			basic_movement_towards_player(delta)
			hands.visible = true
			enemyStopped.visible = false
			setInvisible(true)
		elif retreat == false and is_in_void == true:
			velocity = 0
			hands.visible = false
			enemyStopped.visible = true
			setInvisible(false)
		elif retreat == true and is_in_void == true:
			setInvisible(true)
			hands.visible = true
			enemyStopped.visible = false
			var direction = -global_position.direction_to(player.global_position)
			velocity = direction * movementSpeed
			move_and_slide(velocity)
#	elif stun:
#		var direction = global_position.direction_to(player.global_position)
#		velocity = -(direction * movementSpeed)
#		move_and_slide(velocity)

func _on_AudioStreamPlayer_finished():
	queue_free()

func _on_AvoidBox_area_entered(area):
	if area.is_in_group("player"):
		is_in_void = true
		
func _on_AvoidBox_area_exited(area):
	if area.is_in_group("player"):
		is_in_void = false

func _on_retreat_box_area_entered(area):
	if area.is_in_group("player"):
		retreat = true

func _on_retreat_box_area_exited(area):
	if area.is_in_group("player"):
		retreat = false

func _on_stun_timer_timeout():
	stun = false
	
func _on_HurtBox_area_entered(area):
	if area.is_in_group("attack") and knockbackUnlocked:
		velocity = -velocity * knockback
		stun = true
		$stun_timer.start()

func setInvisible(boo):
	$HurtBox.set_collision_mask_bit(2, boo)
	$HurtBox.set_collision_layer_bit(2, boo)
	$BulletCollision.set_collision_mask_bit(2, boo)
	$BulletCollision.set_collision_layer_bit(2, boo)
