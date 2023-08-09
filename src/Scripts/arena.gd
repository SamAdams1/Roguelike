extends Node

export(Array, PackedScene) var enemies
onready var music = $music
onready var enemySpawnTimer = $enemy_spawn_timer
var num_of_enemies = 0
var difficulty = 2

export(Array, PackedScene) var planets

func _ready():
#	music.play()
	randomize()
	Global.points = 0
	$enemy_spawn_timer.wait_time = difficulty


func _on_enemy_spawn_timer_timeout():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var enemy_number = round(rand_range(0, num_of_enemies))
	
	$Player/Path2D/PathFollow2D.offset = rng.randi_range(0, 3300)
	var instance = enemies[enemy_number].instance()
	instance.global_position = $Player/Path2D/PathFollow2D/Position2D.global_position
	add_child(instance)
	
func _on_spawn_scale_timer_timeout():
#	print($difficulty_timer.wait_time, "difficulty")
	if $enemy_spawn_timer.wait_time > 0.2:
#		print($enemy_spawn_timer.wait_time, "spawn")
		$enemy_spawn_timer.wait_time -= .1
	else:
		pass
	

func _on_enemy_increase_timeout():
#	print($enemy_increase.wait_time)
	if num_of_enemies < (enemies.size() - 1):
		num_of_enemies += 1
	else:
		pass

func _on_planet_loot_spawner_timeout():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var planet_number = round(rand_range(0, (planets.size() - 1)))
	
	$Player/Path2D/PathFollow2D.offset = rng.randi_range(0, 3300)
	var instance = planets[planet_number].instance()
	instance.global_position = $Player/Path2D/PathFollow2D/Position2D.global_position
	add_child(instance)
