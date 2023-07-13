extends KinematicBody2D

export var movementSpeed = 100.0
export var health = 2

var velocity = Vector2.ZERO

onready var player = get_tree().current_scene.get_node('Player')

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
