extends Area2D

export var experience = 1

var spriteRed = preload("res://Sprites/Loot/red gem2.png")
var spriteOrange = preload("res://Sprites/Loot/orange gem.png")
var spriteGreen = preload("res://Sprites/Loot/green gem.png")

var target = null
var speed = 0

onready var sprite = $Sprite
onready var collision = $CollisionShape2D
onready var sound = $collectedSound

func _ready():
	if experience < 5:
		return
	elif experience < 25:
		sprite.texture = spriteOrange
	else:
		sprite.texture = spriteRed

