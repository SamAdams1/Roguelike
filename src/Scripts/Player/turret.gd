extends Sprite
#attacking
var bullet = preload('res://Scenes/bullet.tscn')
onready var sound = $turretShootSound
var waitToFire = false
var toggleFire = true
var fireRate = 0.3
var bulletSpeed = 800


func _physics_process(_delta):
	look_at(get_global_mouse_position())


func _input(event): #shooting has to be in here so only one input is taken per mouse click
	if event.is_action_pressed("attack"):
		toggleFire = !toggleFire
		
	while toggleFire and !waitToFire:
		waitToFire = true
		sound.play()
		fire()
		yield(get_tree().create_timer(fireRate), "timeout")
		waitToFire = false


func fire(): #creates bullet
	var bullet_instance = bullet.instance()
	bullet_instance.position = $BulletSpawnPoint.get_global_position()
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.apply_impulse(Vector2(), Vector2(bulletSpeed, 0).rotated(rotation))
	get_tree().get_root().call_deferred("add_child", bullet_instance)
