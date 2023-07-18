extends KinematicBody2D
var velocity = Vector2.ZERO

#Movement
var speed = 500
var friction = 0.001
var acceleration = 0.1
onready var shipSprite = $ship
onready var shipMovingSprite = $ship/shipMovingFlames
onready var turretSprite = $turret

#Health
var playerHealth = 15
onready var healthBar = get_node('%healthBar')
onready var healthBarUnder = get_node('%healthBarUnder')
onready var updateTween = $GUILayer/GUI/healthBarUnder/Tween
var takingDamage = false

#Levels
var experience = 0 
var experienceLevel = 1
var collectedExperience = 0
onready var expBar = get_node('%ExperienceBar')
onready var labelLevel = get_node('%labelLevel')

#shipShooting
var fireRate = 0.5
var bullet = preload('res://Scenes/bullet.tscn')
var bulletSpeed = 1200
var waitToFire = false


func _ready():
	$GUILayer.visible = true
	setExpBar(experience, calculateExperienceCap())
	healthBar.max_value = playerHealth
	healthBar.value = playerHealth
	healthBarUnder.max_value = playerHealth
	healthBarUnder.value = playerHealth


func _physics_process(delta):
	movement(delta)
	shipLookDirectionMoving()
	while !waitToFire:
		waitToFire = true
#		sound.play()
		fire($ship/shipBulletPoint1)
		fire($ship/shipBulletPoint2)
		fire($ship/shipBulletPoint3)
		yield(get_tree().create_timer(fireRate), "timeout")
		waitToFire = false


func movement(delta):
	var input_velocity = Vector2.ZERO
	
	if Input.is_action_pressed("right"):
		input_velocity.x += 1
	if Input.is_action_pressed("left"):
		input_velocity.x -= 1
	if Input.is_action_pressed("down"):
		input_velocity.y += 1
	if Input.is_action_pressed("up"):
		input_velocity.y -= 1
	input_velocity = input_velocity.normalized() * speed

	#acceleration
	if input_velocity.length() > 0:
		velocity = velocity.linear_interpolate(input_velocity, acceleration)
	else:
	#deceleration
		velocity = velocity.linear_interpolate(Vector2.ZERO, friction)
	velocity = move_and_slide(velocity)
#	print(velocity.y, "  ||  ", velocity.x, "  ||  ", input_velocity)

func shipLookDirectionMoving():
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


func isShipMoving():
	if Input.is_action_pressed("right") or Input.is_action_pressed("down") or Input.is_action_pressed("left") or Input.is_action_pressed("up"):
		return true
	else:
		return false


func _on_HurtBox_hurt(damage):
	playerHealth -= damage
	healthBar.value = playerHealth
	updateTween.interpolate_property(healthBarUnder, 'value', healthBarUnder.value, playerHealth, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.3)
	updateTween.start()
	spriteDamageFlicker()
	if playerHealth <= 0:
#		yield(get_tree().create_timer(1.0), "timeout")
		get_tree().change_scene("res://Scenes/Utility/GameOverScreen.tscn")

func spriteDamageFlicker():
	takingDamage = true
	shipSprite.visible = false
	turretSprite.visible = false
	yield(get_tree().create_timer(.2), "timeout")
	turretSprite.visible = true
	shipSprite.visible = true
	takingDamage = false


#Experience/Leveling
func _on_GrabArea_area_entered(area):
	if area.is_in_group('loot'):
		area.target = self

func _on_CollectArea_area_entered(area):
	if area.is_in_group('loot'):
		var gemExp = area.collect()
		calculateExperience(gemExp)

func calculateExperience(gemEXP):
	var expRequired = calculateExperienceCap()
	collectedExperience += gemEXP
	
	if experience + collectedExperience >= expRequired: #Level Up
		collectedExperience -= expRequired - experience
		experienceLevel += 1
		labelLevel.text = str("LEVEL: ", experienceLevel)
		experience = 0
		expRequired = calculateExperienceCap()
		calculateExperience(0)
	else:
		experience += collectedExperience
		collectedExperience = 0
	
	setExpBar(experience, expRequired)
	
func calculateExperienceCap():
	var expCap = experienceLevel
	if experienceLevel < 20:
		expCap = experienceLevel * 5
	elif experienceLevel < 40:
		expCap = 95 * (experienceLevel - 19) * 8
	else:
		expCap = 255 + (experienceLevel -39) * 12
	return expCap

func setExpBar(setValue = 1, setMaxValue = 100):
	expBar.value = setValue
	expBar.max_value = setMaxValue
	
#ShipShooting
func fire(spawnPoint): #creates bullet
	var bullet_instance = bullet.instance()
	bullet_instance.position = spawnPoint.get_global_position()
	bullet_instance.rotation_degrees = shipSprite.rotation_degrees
	bullet_instance.apply_impulse(Vector2(), Vector2(bulletSpeed, 0).rotated(shipSprite.rotation))
	get_tree().get_root().call_deferred("add_child", bullet_instance)
	
#	print($ship/shipBulletPoint1.rotation, shipSprite.rotation)













