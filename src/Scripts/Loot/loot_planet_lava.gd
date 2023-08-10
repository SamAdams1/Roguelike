extends KinematicBody2D
var damageNumbers = preload("res://Scenes/Enemies/DamageNumbers.tscn")
var explosion = preload("res://Scenes/Explosion.tscn")
var xpGem = preload("res://Scenes/Objects/experienceGem.tscn")
var coin = preload("res://Scenes/Objects/coin.tscn")
var healthDrop = preload("res://Scenes/Objects/healthDropped.tscn")
export var health = 2
export var experienceDroppedValue = 1
export var coinDroppedValue = 10
export var healthDroppedValue = 10
export var movementSpeed = 0
var notDead = true
var explosion_instance = explosion.instance()
onready var player = get_tree().current_scene.get_node('Player')
onready var lootBase = get_tree().current_scene.get_node('lootBase')
onready var hurtBox = $HurtBox/CollisionShape2D
onready var hitBox = $HitBox/CollisionShape2D
onready var sprite = $AnimatedSprite
onready var sound = $DeathExplosionSound
onready var playerCollision = $collision_shape
onready var bulletCollision = $BulletCollision/CollisionShape2D
func createLoot():
	var spawnChance = round(rand_range(0, 10))
	
	if spawnChance <= 4and player.playerHealth < player.healthBar.max_value / 2:
		var healing = healthDrop.instance()
		healing.healthDropped = healthDroppedValue
		healing.global_position = global_position
		lootBase.call_deferred("add_child", healing)
		
	else:
		var newCoin = coin.instance()
		newCoin.coinValue = coinDroppedValue
		newCoin.global_position = global_position
		lootBase.call_deferred("add_child", newCoin)
		
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
			explosion_instance.position = get_global_position()
			get_tree().get_root().add_child(explosion_instance)
			createLoot()
			
func disableEnemyOnDead():
	playerCollision.call_deferred("set", "disabled", true)
	bulletCollision.call_deferred("set", "disabled", true)
	hitBox.call_deferred("set", "disabled", true)
	movementSpeed = 0
	sprite.visible = false
	queue_free()
