extends RigidBody2D

var explosion = preload("res://Scenes/Explosion.tscn")
onready var sound = $bulletHitSound
onready var regBulletHit = preload("res://Audio/SFX/hit.wav")
onready var explosiveBulletHit = preload("res://Audio/SFX/short-explosion.wav")
onready var sprite = $Sprite
onready var hitBox = $HitBox/CollisionShape2D
onready var collision = $CollisionShape2D

onready var statUpgrade = preload("res://Scenes/Utility/StatUpgrade.tscn")

var bulletHealth = Global.bulletHealth
onready var bulletDamageMultiplier = Global.bulletDamageMultiplier


var target = null
var direction = Vector2.RIGHT
onready var speed = 400
var homingBulletUnlocked = false
var explosiveBulletUnlocked = false

func _ready():
	$HitBox.damage += bulletDamageMultiplier
	var player = get_tree().current_scene.get_node('Player')

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
			explosion_instance.scale = Vector2(2,2)
			explosion_instance.position = get_global_position()
			get_tree().get_root().add_child(explosion_instance)
			sound.stream = explosiveBulletHit
			sound.play()
		else:
			hitBox.call_deferred("set", "disabled", true)
			collision.call_deferred("set", "disabled", true)
			var explosion_instance = explosion.instance()
			explosion_instance.position = get_global_position()
			get_tree().get_root().add_child(explosion_instance)
			sound.stream = regBulletHit
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
