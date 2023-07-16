extends KinematicBody2D
var velocity = Vector2.ZERO

#Movement
var speed = 500
var friction = 0.001
var acceleration = 0.1
var playerHealth = 15
onready var sprite = $ship

#Levels
var experience = 0 
var experienceLevel = 1
var collectedExperience = 0
onready var expBar = get_node('%ExperienceBar')
onready var labelLevel = get_node('%labelLevel')

func _ready():
	setExpBar(experience, calculateExperienceCap())

#movement
func _physics_process(delta):
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
	

	if Input.is_action_pressed("up"):
		sprite.rotation_degrees = -90
	if Input.is_action_pressed("down"):
		sprite.rotation_degrees = 90
	if Input.is_action_pressed("left"):
		sprite.rotation_degrees = 180
	if Input.is_action_pressed("right"):
		sprite.rotation_degrees = 0
	if Input.is_action_pressed("left") and Input.is_action_pressed("up") and velocity.x < -1:
		sprite.rotation_degrees = -125
	if Input.is_action_pressed("left") and Input.is_action_pressed("down") and velocity.x < -1:
		sprite.rotation_degrees = 125
	if Input.is_action_pressed("right") and Input.is_action_pressed("up") and velocity.x > 1:
		sprite.rotation_degrees = -50
	if Input.is_action_pressed("right") and Input.is_action_pressed("down") and velocity.x > 1:
		sprite.rotation_degrees = 50
	#print(velocity.y, "||", velocity.x)


func _on_HurtBox_hurt(damage):
	playerHealth -= damage
	print(playerHealth)
	
	if playerHealth <= 0:
		yield(get_tree().create_timer(1.0), "timeout")
		get_tree().reload_current_scene()


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












