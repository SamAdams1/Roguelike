extends "res://Scripts/EnemyScripts/enemy_core.gd"

var is_in_void = false
var retreat = false

func _process(delta):
	if is_in_void == false and retreat == false:
		basic_movement_towards_player(delta)
	elif retreat == false and is_in_void == true:
		velocity = 0
	elif retreat == true and is_in_void == true:
		var direction = -global_position.direction_to(player.global_position)
		velocity = direction * movementSpeed
		move_and_slide(velocity)

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
