extends Area2D

var direction = Vector2.RIGHT
var speed = 400
var target = null

func _physics_process(delta):
	translate(direction * speed * delta)
	if target:
		direction = target.global_position - global_position
		direction = direction.normalized()
		look_at(target.global_position)

func _on_aim_bullet_body_entered(body):
	if body.is_in_group("player"):
		pass
	queue_free()


func _on_aiming_area_body_entered(body):
	target = body


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
