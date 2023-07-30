extends Area2D

export var experience = 1
export var speed = -5
export var speedMultiplier = 10

var spriteRed = preload("res://Sprites/Loot/red gem2.png")
var spriteOrange = preload("res://Sprites/Loot/orange gem.png")
var spriteGreen = preload("res://Sprites/Loot/green gem.png")
onready var player = get_tree().current_scene.get_node('Player')

var target = null


onready var sprite = $Sprite
onready var collision = $CollisionShape2D
onready var sound = $collectedSound

func _ready(): #sets color of xp gem
	if experience < 5:
		return
	elif experience < 25:
		sprite.texture = spriteOrange
	else:
		sprite.texture = spriteRed

func _physics_process(delta):
	global_position = global_position.move_toward(player.global_position, speed)
	speed += speedMultiplier * delta

func collect():
	sound.play()
	collision.call_deferred("set", "disabled", true)
	sprite.visible = false
	return experience

func _on_collectedSound_finished():
	queue_free()
