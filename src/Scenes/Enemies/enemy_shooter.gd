extends "res://Scripts/EnemyScripts/enemy_core.gd"

var is_in_void = false
var enemyHealth = 15

onready var firingPositions := $FiringPositions
var plBullet := preload("res://Scenes/EnemyBullet.tscn")
onready var fireTimer := $FireTimer

export var fireRate := 1.0

func _process(delta):
	
	look_at(player.position)
	
	if fireTimer.is_stopped():
		fire()
		fireTimer.start(fireRate)
	
	if is_in_void == false:
		basic_movement_towards_player(delta)
		print(is_in_void)
	elif is_in_void == true:
		print(is_in_void)
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
		
		
func fire():
	for child in firingPositions.get_children():
		var bullet := plBullet.instance()
		bullet.global_position = child.global_position
		get_tree().current_scene.add_child(bullet)
		
