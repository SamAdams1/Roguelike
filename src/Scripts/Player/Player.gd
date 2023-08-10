extends KinematicBody2D

#upgradable stats
var speed = Global.playerMovementSpeed
var playerHealth = Global.playerHealth
var boostCapacity = Global.boostCapacity
var boostValue = Global.boostValue
var fireRate = Global.fireRate
var bulletSpeed = Global.bulletSpeed

#Movement
onready var shipSprite = $ship
onready var shipMovingSprite = $ship/shipMovingFlames
#onready var shipMovingSound = $sounds/shipMovingSound
onready var shipMovingSound = $sounds/new_ship_sound
onready var boostFlames = $ship/shipBoostFlames
onready var boostSound = $sounds/boostSound
onready var boostBar = $boostBar
var velocity = Vector2.ZERO
var friction = 0.001
var acceleration = 0.1
var nonBoostValue = 1
var boostAmount = 2
var canBoost = true
var lookNotPressed = true
var lookUnlocked = false
var boostUnlocked = false

#Health
onready var deathSound = $sounds/deathSound
onready var hurtBox = $HurtBox/CollisionShape2D
onready var healthBar = get_node('%healthBar')
onready var healthBarUnder = get_node('%healthBarUnder')
onready var updateTween = $GUILayer/GUI/healthBarUnder/Tween
var takingDamage = false


#Levels
onready var expBar = get_node('%ExperienceBar')
onready var labelLevel = get_node('%labelLevel')
onready var levelUpSound = $sounds/levelUpSound
onready var skillTree = $GUILayer/GUI/SkillTree
onready var statUpgrade = $GUILayer/GUI/StatUpgrade
var experience = 0 
var experienceLevel = 0
var collectedExperience = 0
var homingBulletUnlocked = false
var explosiveBulletUnlocked = false

#Directional Ship Shooting
onready var turretSprite = $turret
onready var directionalShootSound = $sounds/directionalShootSound
var directionalBullet = preload("res://Scenes/directionalBullet.tscn")
var waitToFire = false
var toggleFire = false
var directionalShootUnlocked = false
onready var directionalShootLevel = 0
var directionalShoot = []


#Auto Aim Bullets
onready var autoFireSound = $sounds/autoFireSound
var autoBullet = preload("res://Scenes/autoBullet.tscn")
var autoBulletWaitTimer = false
var nearestDistance = 100_000
var nearestEnemy = null
var enemyClose = []
var autoAimUnlocked = false
var autoAimLevel = 0


#loot
onready var moneyLabel = $GUILayer/GUI/moneyLabel
var money = 0
onready var storeShopScreen = $GUILayer/GUI/StoreShopScreen


func _ready():
#	var master_sound = AudioServer.get_bus_index("Master")
#	AudioServer.set_bus_mute(master_sound, true)
	
	labelLevel.text = "Level: " + str(experienceLevel)
	skillTree.visible = false
	statUpgrade.visible = false
	$GUILayer.visible = true
	boostFlames.visible = false
	boostBar.visible = false
	storeShopScreen.visible = false
	
	shipMovingSound.play()
	
	setExpBar(experience, calculateExperienceCap())
	healthBar.max_value = playerHealth
	healthBar.value = playerHealth
	healthBarUnder.max_value = playerHealth
	healthBarUnder.value = playerHealth
	boostBar.max_value = boostCapacity
	
	
	skillTree.connect("upgradePlayer", self, 'updatePlayerSkills')
#	statUpgrade.connect('upgradeStats', self, 'upgradePlayerStats')


func _physics_process(delta):
	if get_tree().paused == false:
		movement(delta)
		shipLookDirectionMoving(delta)
		autoAim()
		if !waitToFire:
			directionalFire()
			waitToFire = true
			yield(get_tree().create_timer(fireRate), "timeout")
			waitToFire = false

func movement(_delta):
	var input_velocity = Vector2.ZERO
	
	if Input.is_action_pressed("right") and lookNotPressed:
		input_velocity.x += 1
	if Input.is_action_pressed("left") and lookNotPressed:
		input_velocity.x -= 1
	if Input.is_action_pressed("down") and lookNotPressed:
		input_velocity.y += 1
	if Input.is_action_pressed("up") and lookNotPressed:
		input_velocity.y -= 1
	input_velocity = input_velocity.normalized() * (speed + nonBoostValue)
	
	#acceleration
	if input_velocity.length() > 0:
		velocity = velocity.linear_interpolate(input_velocity, acceleration)
	else:
	#deceleration
		velocity = velocity.linear_interpolate(Vector2.ZERO, friction)
	velocity = move_and_slide(velocity)
#	print(velocity.y, "  ||  ", velocity.x, "  ||  ", input_velocity, "  ||  ", velocity)


func shipLookDirectionMoving(delta):
	if Input.is_action_pressed("up"):
		shipSprite.rotation_degrees = -90
	if Input.is_action_pressed("down"):
		shipSprite.rotation_degrees = 90
	if Input.is_action_pressed("left"):
		shipSprite.rotation_degrees = 180
	if Input.is_action_pressed("right"):
		shipSprite.rotation_degrees = 0
	if Input.is_action_pressed("left") and Input.is_action_pressed("up"):# and velocity.x < -1:
		shipSprite.rotation_degrees = -135
	if Input.is_action_pressed("left") and Input.is_action_pressed("down"):# and velocity.x < -1:
		shipSprite.rotation_degrees = 135
	if Input.is_action_pressed("right") and Input.is_action_pressed("up"):# and velocity.x > 1:
		shipSprite.rotation_degrees = -45
	if Input.is_action_pressed("right") and Input.is_action_pressed("down"):# and velocity.x > 1:
		shipSprite.rotation_degrees = 45
	
	if !takingDamage:
		shipMovingSprite.visible = isShipMoving()
		if boostUnlocked:
			boost()
			calculateBoostBar(delta)
	
	if Input.is_action_pressed("look") and lookUnlocked:
		lookNotPressed = false
	else:
		lookNotPressed = true
	
func boost():
	if Input.is_action_pressed("ui_select") and isShipMoving() and canBoost:
		boostFlames.visible = true
		nonBoostValue = boostValue
		if !boostSound.playing:
			boostSound.play()
	else:
		nonBoostValue = 1
		boostFlames.visible = false
		boostSound.stop()

func calculateBoostBar(delta):
	if Input.is_action_pressed("ui_select"):
		boostAmount -= delta
	if boostAmount <= 0:
		canBoost = false
	if boostAmount == boostCapacity:
		canBoost = true
	if boostFlames.visible == false and boostAmount < boostCapacity:
		boostAmount += delta
	boostBar.value = boostAmount


func _input(event):
	if event.is_action_pressed("fire"):
		toggleFire = !toggleFire

func isShipMoving():
	if ((Input.is_action_pressed("right") or Input.is_action_pressed("down") or Input.is_action_pressed("left") or Input.is_action_pressed("up")) and lookNotPressed):
		shipMovingSound.volume_db = -25
		return true
	
	else:
		shipMovingSound.volume_db = -100
		return false



func _on_HurtBox_hurt(damage):
	playerHealth -= damage
	healthBar.value = playerHealth
	updateTween.interpolate_property(healthBarUnder, 'value', healthBarUnder.value, playerHealth, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.3)
	updateTween.start()
	if playerHealth == 0:
		hurtBox.call_deferred("set", "disabled", true)
		shipSprite.visible = false
		turretSprite.visible = false
		speed = 0
		deathSound.play()
	elif playerHealth > 0:
		spriteDamageFlicker(.2)

func _on_deathSound_finished():
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://Scenes/Menus/GameOverScreen.tscn")

func spriteDamageFlicker(time):
	takingDamage = true
	shipSprite.visible = false
	turretSprite.visible = false
	yield(get_tree().create_timer(time), "timeout")
	turretSprite.visible = true
	shipSprite.visible = true
	takingDamage = false


#Experience/Leveling
func _on_GrabArea_area_entered(area):
	if area.is_in_group('loot'):
		area.target = self

func _on_CollectArea_area_entered(area):
	if area.is_in_group('xp'):
		var gemExp = area.collect()
		calculateExperience(gemExp)
	if area.is_in_group('coins'):
		money += area.collect()
		moneyLabel.text = str(money)
	if area.is_in_group('health'):
		playerHealth += area.collect()
		healthBar.value = playerHealth
		if playerHealth > healthBar.max_value:
			playerHealth = healthBarUnder.max_value

func calculateExperience(gemEXP):
	var expRequired = calculateExperienceCap()
	collectedExperience += gemEXP

	if experience + collectedExperience >= expRequired: #Level Up
		levelUpSound.play()
		collectedExperience -= expRequired - experience
		experienceLevel += 1
		experience = 0
		expRequired = calculateExperienceCap()
		
	else:
		experience += collectedExperience
		collectedExperience = 0
	setExpBar(experience, expRequired)
	
func calculateExperienceCap():
	var expCap = experienceLevel
	if experienceLevel == 0:
		expCap = 1
	elif experienceLevel < 20:
		expCap = experienceLevel * 5
	elif experienceLevel < 40:
		expCap = 95 * (experienceLevel - 19) * 8
	else:
		expCap = 255 + (experienceLevel -39) * 12
	return expCap

func setExpBar(setValue = 1, setMaxValue = 100):
	expBar.value = setValue
	expBar.max_value = setMaxValue

signal firstLevel

func _on_levelUpSound_finished():
	labelLevel.text = str("LEVEL: ", experienceLevel)
	skillTree.points += 1
	statUpgrade.statPoints += 1
	statUpgrade.updatePoints()
	skillTree.updatePoints()
	toggleFire = false
	
	if experienceLevel % 2 != 0 or experienceLevel == 1:
		emit_signal("firstLevel", experienceLevel)
		skillTree.visible = true
	
	statUpgrade.visible = true
	shipMovingSound.volume_db = -100
	boostSound.stop()
	get_tree().paused = true
	calculateExperience(0)

func upgradePlayer():
	toggleFire = true
	skillTree.visible = false
	statUpgrade.visible = false
	get_tree().paused = false
	calculateExperience(0)
	


func updatePlayerSkills(target, category):
	if category == 'directional':
		directionalShootUnlocked = true
		directionalShootLevel += 1
		directionalShoot.append(target)
	elif category == 'autoaim':
		autoAimLevel += 1
		autoAimUnlocked = true
	elif target == 'look':
		lookUnlocked = true
	elif target == 'boost':
		boostUnlocked = true
		boostBar.visible = true
	elif target == 'tracerBullet':
		homingBulletUnlocked = true
	elif target == 'explosiveBullet':
		explosiveBulletUnlocked = true

func setStats():
	speed = Global.playerMovementSpeed
	healthBar.max_value = Global.playerHealth
	healthBarUnder.max_value = Global.playerHealth
	boostValue = Global.boostValue
	boostCapacity = Global.boostCapacity
	boostBar.max_value = boostCapacity
	boostAmount = boostCapacity
	fireRate = Global.fireRate
	bulletSpeed = Global.bulletSpeed


func changeShipColor(number):
	if number == 1:
			shipSprite.texture = load("res://Sprites/Player/greennewShip.png")
	elif number == 2: 
			shipSprite.texture = load("res://Sprites/Player/bluenewShip.png")
	else: 
			shipSprite.texture = load("res://Sprites/Player/newShip.png")




#ShipShooting
func directionalFire():
	if directionalShootUnlocked and toggleFire and !waitToFire:
		var counter = 1
		var limit =  directionalShoot.size()
		while counter <= limit:
			var spawnPoint = directionalShootDetermine(counter, limit)
			
			directionalShootSound.play()
			var bullet_instance = directionalBullet.instance()
			bullet_instance.position = spawnPoint.get_global_position()
			bullet_instance.rotation_degrees = shipSprite.rotation_degrees
			
			var shipMovingMultiplier = 0
#			var shipMovingMultiplier = abs(velocity.y) + abs(velocity.x)
#			if lookNotPressed:
#				shipMovingMultiplier /= 2
#			else:
#				shipMovingMultiplier /= 4
			bullet_instance.apply_impulse(Vector2(), Vector2(bulletSpeed + shipMovingMultiplier, 0).rotated(shipSprite.rotation))
			get_tree().get_root().call_deferred("add_child", bullet_instance)
			counter += 1

func directionalShootDetermine(counter, limit):
	if limit == 1:
		if counter == 1:
			return $ship/bulletSpawnPoints/directional2
	elif limit == 2:
		if counter == 1:
			return $ship/bulletSpawnPoints/directional3
		if counter == 2:
			return $ship/bulletSpawnPoints/directional1
	else:
		if counter == 1:
			return $ship/bulletSpawnPoints/directional1
		if counter == 2:
			return $ship/bulletSpawnPoints/directional2
		if counter == 3:
			return $ship/bulletSpawnPoints/directional3



func findNearestEnemy():
	for enemy in Global.closeEnemies:
		var distance = self.global_position.distance_to(enemy.global_position)
		if distance < nearestDistance:
			nearestDistance = distance
			nearestEnemy = enemy
			Global.nearestEnemy = enemy
#			print(nearestDistance, '||', nearestEnemy)


func autoAim():
	if autoAimUnlocked:
		findNearestEnemy()
		if nearestEnemy != null and !autoBulletWaitTimer and playerHealth > 0:
			autoBulletWaitTimer = true
			var counter = 0
			while counter < autoAimLevel:
				var burstTimer = true
				if burstTimer:
					var bullet_instance = autoBullet.instance()
					bullet_instance.global_position = global_position
					if is_instance_valid(nearestEnemy):
						autoFireSound.play()
						var direction = (self.global_position - nearestEnemy.global_position).normalized() * -1
						bullet_instance.apply_impulse(Vector2(), direction * bulletSpeed)
						get_parent().add_child(bullet_instance)
					burstTimer = false
				yield(get_tree().create_timer(0.1), "timeout")
				burstTimer = true
				counter += 1
			
			yield(get_tree().create_timer(fireRate), "timeout")
			autoBulletWaitTimer = false


func _on_autoAimArea_body_entered(body):
	if body.is_in_group('enemy'):
#		print(Global.closeEnemies)
		Global.closeEnemies.append(body)

func _on_autoAimArea_body_exited(body):
#	print(Global.closeEnemies)
	nearestDistance = 100_000
	Global.closeEnemies.erase(body)







