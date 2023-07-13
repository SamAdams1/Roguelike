extends KinematicBody2D
#player movement
var velocity = Vector2.ZERO
var speed = 500
var friction = 0.01
var acceleration = 0.1
#onready var animationTree = $AnimationTree

#Stats
var playerHealth = 50

#attacking
var bullet = preload('res://Scenes/bullet.tscn')
var waitToFire = false
var toggleFire = false
var fireRate = 1
var bulletSpeed = 500

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
	
#func _physics_process(_delta):
#	handle_input()
#	
#	if velocity != Vector2.ZERO:
#		animationTree.set("parameters/Move/blend_position", velocity)
	
	
#func handle_input():
	#movement
#	velocity.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
#	velocity.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	
	#fixes double speed on diagonals
#	velocity = velocity.normalized()
#	velocity = move_and_slide(velocity * playerSpeed)
	
	#look_at(get_global_mouse_position())
	
	#makes player look where moving
	#MIGHT NEED IN THE FUTURE
#	if Input.is_action_pressed("right"):
#		rotation_degrees = -90
#	if Input.is_action_pressed("left"):
#		rotation_degrees = 90
#	if Input.is_action_pressed("up"):
#		rotation_degrees = 180
#	if Input.is_action_pressed("down"):
#		rotation_degrees = 0
#	if Input.is_action_pressed("right") and Input.is_action_pressed("up") and velocity.x > 1:
#		rotation_degrees = -125
#	if Input.is_action_pressed("left") and Input.is_action_pressed("up") and velocity.x < -1:
#		rotation_degrees = 125
#	if Input.is_action_pressed("right") and Input.is_action_pressed("down") and velocity.x > 1:
#		rotation_degrees = -50
#	if Input.is_action_pressed("left") and Input.is_action_pressed("down") and velocity.x < -1:
#		rotation_degrees = 50


func _on_HurtBox_hurt(damage):
	playerHealth -= damage
	print(playerHealth)
