extends KinematicBody2D
var speed = 200
var velocity = Vector2.ZERO



func _physics_process(_delta):
	handle_input()
	
	
func handle_input():
	#movement
	velocity.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	velocity.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	#fixes double speed on diagnols
	velocity = velocity.normalized()
	velocity = move_and_slide(velocity * speed)
	
	look_at(get_global_mouse_position())
