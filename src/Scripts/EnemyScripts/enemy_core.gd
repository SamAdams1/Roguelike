extends KinematicBody2D

var damageNumbers = preload("res://Scenes/Enemies/DamageNumbers.tscn")
var explosion = preload("res://Scenes/Explosion.tscn")
var xpGem = preload("res://Scenes/Objects/experienceGem.tscn")
var coin = preload("res://Scenes/Objects/coin.tscn")
var healthDrop = preload("res://Scenes/Objects/healthDropped.tscn")


onready var player = get_tree().current_scene.get_node('Player')
onready var playerCollision = $PlayerCollision
onready var bulletCollision = $BulletCollision/CollisionShape2D
onready var hurtBox = $HurtBox/CollisionShape2D
onready var hitBox = $HitBox/CollisionShape2D
onready var sprite = $Sprite
onready var sound = $DeathExplosionSound
onready var lootBase = get_tree().current_scene.get_node('lootBase')
var notDead = true

var velocity = Vector2.ZERO
#enemy stats you can change in inspector
export var movementSpeed = 100.0
export var health = 2
export var experienceDroppedValue = 1
export var coinDroppedValue = 1
export var healthDroppedValue = 5
export var knockback = 0


func basic_movement_towards_player(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * movementSpeed
	move_and_slide(velocity)


func _on_HurtBox_hurt(damage):
	health -= damage
	if notDead:
		var text = damageNumbers.instance()
		text.amount = damage
		add_child(text)
		
		if health <= 0:
			notDead = false
			disableEnemyOnDead()
			sound.play()
			Global.points += 1
			#explosion animation
			var explosion_instance = explosion.instance()
			explosion_instance.position = get_global_position()
			get_tree().get_root().add_child(explosion_instance)
			
			createLoot()
			


func disableEnemyOnDead():
	playerCollision.call_deferred("set", "disabled", true)
	bulletCollision.call_deferred("set", "disabled", true)
	hitBox.call_deferred("set", "disabled", true)
	hurtBox.call_deferred("set", "disabled", true)
	movementSpeed = 0
	sprite.visible = false


func createLoot():
	var spawnChance = round(rand_range(0, 10))
	
	if int(spawnChance) == 0 and player.playerHealth < player.healthBar.max_value / 2:
		var healing = healthDrop.instance()
		healing.healthDropped = healthDroppedValue
		healing.global_position = global_position
		lootBase.call_deferred("add_child", healing)
		
	elif spawnChance > 5:
		var newXPGem = xpGem.instance()
		newXPGem.experience = experienceDroppedValue
		newXPGem.global_position = global_position
		lootBase.call_deferred("add_child", newXPGem)
		
	elif int(spawnChance) % 2 == 0:
		var newCoin = coin.instance()
		newCoin.coinValue = coinDroppedValue
		newCoin.global_position = global_position
		lootBase.call_deferred("add_child", newCoin)
		
func _on_difficulty_scale_timeout():
	health += 1
	movementSpeed += 10
