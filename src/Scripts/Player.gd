extends KinematicBody2D
#player movement
var velocity = Vector2.ZERO
var speed = 200

#attacking
var bullet = preload('res://Scenes/bullet.tscn')
var waitToFire = false
var fireRate = 0.5
var bulletSpeed = 500


func _physics_process(_delta):
	handle_input()
	
	
func handle_input():
	#movement
	velocity.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	velocity.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	#fixes double speed on diagonals
	velocity = velocity.normalized()
	velocity = move_and_slide(velocity * speed)
	
	
	
	look_at(get_global_mouse_position())
	if Input.is_action_pressed("attack") and !waitToFire:
		fire()
		waitToFire = true
		yield(get_tree().create_timer(fireRate), "timeout")
		waitToFire = false

func fire():
	var bullet_instance = bullet.instance()
	bullet_instance.position = $BulletSpawnPoint.get_global_position()
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.apply_impulse(Vector2(), Vector2(bulletSpeed, 0).rotated(rotation))
	get_tree().get_root().call_deferred("add_child", bullet_instance)
