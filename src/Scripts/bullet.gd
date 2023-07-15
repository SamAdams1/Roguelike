extends RigidBody2D
var explosion = preload("res://Scenes/Explosion.tscn")
onready var sound = $bulletHitSound
onready var sprite = $Sprite

func _on_bullet_body_entered(body):
	if body.is_in_group("enemy"):
		sound.play()
		sprite.visible = false
		var explosion_instance = explosion.instance()
		explosion_instance.position = get_global_position()
		get_tree().get_root().add_child(explosion_instance)
		

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_bulletHitSound_finished():
	queue_free()
