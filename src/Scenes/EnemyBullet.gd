extends RigidBody2D

var pBulletEffect := preload("res://Scenes/EnemyBulletEffect.tscn")

export var speed: float = 500
onready var sound = $bulletHitSound
onready var sprite = $Sprite
var direction = Vector2.RIGHT
var target = null

func _physics_process(delta):
	translate(direction * speed * delta)
	if target:
		direction = target.global_position - global_position
		direction = direction.normalized()
		look_at(target.global_position)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	
func _on_Bullet_area_entered(area):
	if area.is_in_group("player"):
		var bulletEffect := pBulletEffect.instance()
		bulletEffect.position = position
		get_parent().add_child(bulletEffect)
		
		area.damage(1)
		queue_free()
		
		
func _on_bullet_body_entered(body):
	if body.is_in_group("player"):
		sound.play()
		sprite.visible = false
		var explosion_instance = pBulletEffect.instance()
		explosion_instance.position = get_global_position()
		get_tree().get_root().add_child(explosion_instance)
