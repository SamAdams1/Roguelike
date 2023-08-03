extends RigidBody2D

var explosion = preload("res://Scenes/Explosion.tscn")
onready var sound = $bulletHitSound
onready var sprite = $Sprite
onready var hitBox = $HitBox/CollisionShape2D

onready var bulletHealth = Global.bulletHealth
var target = null
var direction = Vector2.RIGHT
onready var speed = 400
var homingBulletUnlocked = false
var explosiveBulletUnlocked = false

func _ready():
	var player = get_tree().current_scene.get_node('Player')
#	player.connect("upgradeBullet", self, 'upgradeBullets')
	homingBulletUnlocked = player.homingBulletUnlocked
	explosiveBulletUnlocked = player.explosiveBulletUnlocked
	if homingBulletUnlocked:
		bulletHealth = 0

func _physics_process(delta):
	if target and is_instance_valid(target) and homingBulletUnlocked:
		translate(direction * speed * delta)
		direction = target.global_position - global_position
		direction = direction.normalized()
		look_at(target.global_position)
	if target and !is_instance_valid(target):
		queue_free()
		
func _on_bigBullet_body_entered(body):
	if body.is_in_group("enemy"):
		sprite.visible = false
		if explosiveBulletUnlocked:
			hitBox.scale = Vector2(10,15)
			var explosion_instance = explosion.instance()
			explosion_instance.scale = Vector2(5,5)
			explosion_instance.position = get_global_position()
			get_tree().get_root().add_child(explosion_instance)
			sound.play()
		else:
			var explosion_instance = explosion.instance()
			explosion_instance.position = get_global_position()
			get_tree().get_root().add_child(explosion_instance)
			sound.play()

func _on_bulletPenetration_area_entered(area):
	if area.is_in_group("enemy"):
		bulletHealth -= 1
		if bulletHealth <= 0:
			self.set_collision_mask_bit(2, true)

func _on_homingArea_body_entered(body):
	if body.is_in_group('enemy') and homingBulletUnlocked:
		target = body
		
func upgradeBullets():
	if target == 'tracerBullet':
		homingBulletUnlocked = true
	elif target == 'explosiveBullet':
		explosiveBulletUnlocked = true

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_bulletHitSound_finished():
	queue_free()


