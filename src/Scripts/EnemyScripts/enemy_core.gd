extends KinematicBody2D

var damageNumbers = preload("res://Scenes/Enemies/DamageNumbers.tscn")
var explosion = preload("res://Scenes/Explosion.tscn")
onready var player = get_tree().current_scene.get_node('Player')
onready var playerCollision = $PlayerCollision
onready var bulletCollision = $BulletCollision/CollisionShape2D
onready var hurtBox = $HurtBox/CollisionShape2D
onready var hitBox = $HitBox/CollisionShape2D
onready var sprite = $Sprite
onready var sound = $DeathExplosionSound
var notDead = true

var velocity = Vector2.ZERO
export var movementSpeed = 100.0
export var health = 2


func basic_movement_towards_player(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * movementSpeed
	move_and_slide(velocity)

func _on_HurtBox_hurt(damage):
	health -= damage
	if notDead:
		var text = damageNumbers.instance()
		text.amount = damage
		add_child(text)
		
		if health <= 0:
			notDead = false
			Global.points += 10
			playerCollision.call_deferred("set", "disabled", true)
			bulletCollision.call_deferred("set", "disabled", true)
			hitBox.call_deferred("set", "disabled", true)
			hurtBox.call_deferred("set", "disabled", true)
			movementSpeed = 0
			sprite.visible = false
			sound.play()
			var explosion_instance = explosion.instance()
			explosion_instance.position = get_global_position()
			get_tree().get_root().add_child(explosion_instance)
	#		queue_free()
		
	print("enemy", health)
