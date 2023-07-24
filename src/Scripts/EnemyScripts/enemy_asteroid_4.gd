extends "res://Scripts/EnemyScripts/enemy_core.gd"

func _process(delta):
	basic_movement_towards_player(delta)

func _on_AudioStreamPlayer_finished():
	queue_free()


func _on_AvoidBox_area_entered(area):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * movementSpeed
	move_and_slide(velocity)
