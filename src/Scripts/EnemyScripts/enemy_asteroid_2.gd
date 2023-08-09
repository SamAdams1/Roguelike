extends "res://Scripts/EnemyScripts/enemy_core.gd"

var stun = false

func _process(delta):
	if stun == false:
		basic_movement_towards_player(delta)
#	elif stun:
#		var direction = global_position.direction_to(player.global_position)
#		velocity = -(direction * movementSpeed)
#		move_and_slide(velocity)


func _on_AudioStreamPlayer_finished():
	queue_free()
	
func _on_stun_timer_timeout():
	stun = false
	
func _on_HurtBox_area_entered(area):
	if area.is_in_group("attack") and knockbackUnlocked:
		velocity = -velocity * knockback
		stun = true
		$stun_timer.start()
