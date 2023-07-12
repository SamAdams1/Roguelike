extends Node

var enemy_asteroid = preload("res://Scenes/Enemies/AsteroidEnemy.tscn")

func _ready():
	randomize()

func _on_enemy_spawn_timer_timeout():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	$Player/Path2D/PathFollow2D.offset = rng.randi_range(0, 3100)
	var instance = enemy_asteroid.instance()
	
	instance.global_position = $Player/Path2D/PathFollow2D/Position2D.global_position
	add_child(instance)
	
	
