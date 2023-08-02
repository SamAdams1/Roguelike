extends Area2D

export var damage = 1
onready var collision= $CollisionShape2D
onready var disableTimer = $DisableHitBoxTimer

func tempDisable():
	collision.call_deferred("set", "disabled", true)
	disableTimer.start()

func _on_DisableHitboxTimer_timeout():
	collision.call_deferred("set", "disabled", false)
