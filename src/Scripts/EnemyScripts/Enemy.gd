extends KinematicBody2D

export var movementSpeed = 100.0
export var health = 2

var velocity = Vector2.ZERO

onready var player = get_tree().current_scene.get_node('Player')
var explosion = preload("res://Scenes/Explosion.tscn")

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * movementSpeed
	move_and_slide(velocity)


func _on_HurtBox_hurt(damage):
	health -= damage
	if health <= 0:
		Global.points += 10

		queue_free()
	#print("enemy", health)

		var explosion_instance = explosion.instance()
		explosion_instance.position = get_global_position()
		get_tree().get_root().add_child(explosion_instance)
		queue_free()
		
	print("enemy", health)
	

