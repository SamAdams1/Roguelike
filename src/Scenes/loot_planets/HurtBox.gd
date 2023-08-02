extends Area2D

enum{Cooldown, HitOnce, DisableHitbox}
export var HurtBoxType = 0

onready var collision = $CollisionShape2D
onready var disableTimer = $DisableTimer

signal hurt(damage)



func _on_HurtBox_area_entered(area):
	if area.is_in_group("attack"):
		if not area.get("damage") == null:
			match HurtBoxType:
				0: #cooldown
					collision.call_deferred("set", "disabled", true)
					disableTimer.start()
				1: #HitOnce
					pass
				2: #DisableHitBox
					if area.has_method("tempDisable"):
						area.tempDisable()
			var damage = area.damage
			emit_signal("hurt", damage)
				
				

func _on_DisableTimer_timeout():
	collision.call_deferred("set", "disabled", false)
