extends "res://Scripts/EnemyScripts/enemy_core.gd"

var is_in_void = false
var enemyHealth = 15

var nearestDistance = 100_000
var nearestPlayer = null
var playerHealth = Global.playerHealth

var autoAimUnlocked = false
var autoBullet = preload("res://Scenes/autoBullet.tscn")
var plBullet := preload("res://Scenes/EnemyBullet.tscn")
var bulletSpeed = Global.bulletSpeed
var autoBulletWaitTimer = false
var autoAimLevel = 0

onready var firingPositions := $FiringPositions
onready var autoFireSound = $sounds/autoFireSound
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


func findPlayer():
	for player in Global.closeplayer:
		var distance = self.global_position.distance_to(player.global_position)
		if distance < nearestDistance:
			nearestDistance = distance
			nearestPlayer = player
			Global.nearestPlayer = player
			
					
func autoAim():
	if autoAimUnlocked:
		findPlayer()
		if nearestPlayer != null and !autoBulletWaitTimer and enemyHealth > 0:
			autoBulletWaitTimer = true
			var counter = 0
			while counter < autoAimLevel:
				var burstTimer = true
				if burstTimer:
					var bullet_instance = autoBullet.instance()
					bullet_instance.global_position = global_position
					if is_instance_valid(nearestPlayer):
						autoFireSound.play()
						var direction = (self.global_position - nearestPlayer.global_position).normalized() * -1
						bullet_instance.apply_impulse(Vector2(), direction * bulletSpeed)
						get_parent().add_child(bullet_instance)
					burstTimer = false
				yield(get_tree().create_timer(0.1), "timeout")
				burstTimer = true
				counter += 1
			
			yield(get_tree().create_timer(fireRate), "timeout")
			autoBulletWaitTimer = false
