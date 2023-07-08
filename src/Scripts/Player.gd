extends KinematicBody2D
#player movement
var velocity = Vector2.ZERO
var playerSpeed = 500
onready var animationTree = $AnimationTree

#attacking
var bullet = preload('res://Scenes/bullet.tscn')
var waitToFire = false
var toggleFire = false
var fireRate = 1
var bulletSpeed = 500


func _physics_process(_delta):
	handle_input()
	
	if velocity != Vector2.ZERO:
		animationTree.set("parameters/Move/blend_position", velocity)
	
	
func handle_input():
	#movement
	velocity.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	velocity.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	
	#fixes double speed on diagonals
	velocity = velocity.normalized()
	velocity = move_and_slide(velocity * playerSpeed)
	
#	look_at(get_global_mouse_position())
	
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
