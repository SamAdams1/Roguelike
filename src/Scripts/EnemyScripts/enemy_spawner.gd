extends Node

var enemy_asteroid = preload("res://Scenes/Enemies/AsteroidEnemy.tscn")

func _on_enemy_spawn_timer_timeout():
	var enemy_position = Vector2(rand_range(-160, 670), rand_range(-90, 390))
	
	while enemy_position.x < 640 and enemy_position.x > -80 or enemy_position.y < 360 and enemy_position.y > -45:
		enemy_position = Vector2(rand_range(-160, 670), rand_range(-90, 390))
		
	Global.instance_node(enemy_asteroid, enemy_position, self)
