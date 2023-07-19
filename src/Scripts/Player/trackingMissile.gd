extends Area2D

var level = 1
var hp = 1
var speed = 500
var damage = 5
var attackSize = 1.0
var knockBackAmount = 100

var lastMovement = Vector2.ZERO
var angle = Vector2.ZERO
var angleLess = Vector2.ZERO
var angleMore = Vector2.ZERO

signal removeFromArray(object)

onready var player = get_tree().current_scene.get_node('Player')

func _ready():
	match level:
		1:
			hp = 1
			speed = 500
			damage = 5
			attackSize = 1.0
			knockBackAmount = 100
