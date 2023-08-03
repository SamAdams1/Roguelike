extends Sprite

#var explosion = preload("res://Scenes/Explosion.tscn")
#var xpGem = preload("res://Scenes/Objects/experienceGem.tscn")
#var coin = preload("res://Scenes/Objects/coin.tscn")
#var healthDrop = preload("res://Scenes/Objects/healthDropped.tscn")

#export var health = 1
#export var experienceDroppedValue = 1
#export var coinDroppedValue = 1
#export var healthDroppedValue = 5

#var explosion_instance = explosion.instance()

#onready var player = get_tree().current_scene.get_node('Player')
#onready var lootBase = get_tree().current_scene.get_node('lootBase')
#onready var hitBox = $HitBox/CollisionShape2D
#onready var sprite = $Sprite


#func createLoot():
#	var spawnChance = round(rand_range(0, 10))
	
#	if int(spawnChance) == 0 and player.playerHealth < player.healthBar.max_value / 2:
#		var healing = healthDrop.instance()
#		healing.healthDropped = healthDroppedValue
#		healing.global_position = global_position
#		lootBase.call_deferred("add_child", healing)
		
#	elif spawnChance > 5:
#		var newXPGem = xpGem.instance()
#		newXPGem.experience = experienceDroppedValue
#		newXPGem.global_position = global_position
#		lootBase.call_deferred("add_child", newXPGem)
		
#	elif int(spawnChance) % 2 == 0:
#		var newCoin = coin.instance()
#		newCoin.coinValue = coinDroppedValue
#		newCoin.global_position = global_position
#		lootBase.call_deferred("add_child", newCoin)

#func _process(delta):
#	pass


#func _on_hitbox_area_entered(area):
#	if area.is_in_group("attack"):
#		health -= 1
#	if health <= 0:
#		area.get_parent.queue_free()
#		explosion_instance.position = get_global_position()
#		get_tree().get_root().add_child(explosion_instance)
		
#		createLoot()
