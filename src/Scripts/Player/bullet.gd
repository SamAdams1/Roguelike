extends RigidBody2D

var explosion = preload("res://Scenes/Explosion.tscn")
onready var sound = $bulletHitSound
onready var sprite = $Sprite

onready var bulletHealth = 2
var target = null



func _on_bullet_body_entered(body):
	if body.is_in_group("enemy"):
		sprite.visible = false
		var explosion_instance = explosion.instance()
		explosion_instance.position = get_global_position()
		get_tree().get_root().add_child(explosion_instance)
		sound.play()
		

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_bulletHitSound_finished():
	queue_free()



func _on_bulletPenetration_area_entered(area):
	if area.is_in_group("enemy"):
		print('h')
		bulletHealth -= 1
		if bulletHealth <= 0:
			self.set_collision_mask_bit(2, true)
