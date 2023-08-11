extends KinematicBody2D

#upgradable stats
var speed = Global.playerMovementSpeed
var playerHealth = Global.playerHealth
var boostCapacity = Global.boostCapacity
var boostValue = Global.boostValue
var fireRate = Global.fireRate
var bulletSpeed = Global.bulletSpeed

#Movement
onready var shipMovingSound = $sounds/new_ship_sound

var velocity = Vector2.ZERO
var friction = 0.001
var acceleration = 0.1


func _ready():
	shipMovingSound.play()



func _physics_process(delta):
	if get_tree().paused == false:
		movement(delta)

func movement(_delta):
	var input_velocity = Vector2.ZERO
	
	if Input.is_action_pressed("right"):
		input_velocity.x += 1
	if Input.is_action_pressed("left"):
		input_velocity.x -= 1
	if Input.is_action_pressed("down"):
		input_velocity.y += 1
	if Input.is_action_pressed("up"):
		input_velocity.y -= 1
	input_velocity = input_velocity.normalized() * (speed)
	
	#acceleration
	if input_velocity.length() > 0:
		velocity = velocity.linear_interpolate(input_velocity, acceleration)
	else:
	#deceleration
		velocity = velocity.linear_interpolate(Vector2.ZERO, friction)
	velocity = move_and_slide(velocity)
#	print(velocity.y, "  ||  ", velocity.x, "  ||  ", input_velocity, "  ||  ", velocity)
