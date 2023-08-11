extends Sprite

var healthDrop = preload("res://Scenes/Objects/healthDropped.tscn")
onready var lootBase = get_tree().current_scene.get_node('lootBase')
onready var hitBox = get_node('%StoreHitBox')


func _on_Area2D_body_entered(body):
	if body.is_in_group('player'):
		Global.store = self
		body.storeShopScreen.visible = true
		body.shipMovingSound.volume_db = -100
		get_tree().paused = true


func spawnHealth(healthDroppedValue):
	var healing = healthDrop.instance()
	healing.healthDropped = healthDroppedValue
	healing.global_position = global_position
	lootBase.call_deferred("add_child", healing)

func killEnemies():
	hitBox.set_collision_mask_bit(2, true)
	hitBox.scale = Vector2(20,15)

