extends Node

export(Array, PackedScene) var enemies
onready var music = $music
var num_of_enemies = 0
var difficulty = 14

export(Array, PackedScene) var planets
var num_of_loot_planets = 0

func _ready():
#	music.play()
	randomize()
	Global.points = 0
	

func _on_enemy_spawn_timer_timeout():
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var enemy_number = round(rand_range(0, num_of_enemies))
	
	$Player/Path2D/PathFollow2D.offset = rng.randi_range(0, 3300)
	var instance = enemies[enemy_number].instance()
	
	instance.global_position = $Player/Path2D/PathFollow2D/Position2D.global_position
	add_child(instance)
	
func _on_difficulty_timer_timeout():
	if $enemy_spawn_timer.wait_time > 0.5:
		$enemy_spawn_timer.wait_time -= 0.2

func _on_enemy_increase_timeout():
	$enemy_spawn_timer.wait_time = (difficulty - 2)
	if num_of_enemies < (enemies.size() - 1):
		num_of_enemies += 1
	else:
		pass


func _on_planet_loot_spawner_timeout():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var planet_number = round(rand_range(0, num_of_loot_planets))
	
	$Player/Path2D/PathFollow2D.offset = rng.randi_range(0, 3300)
	var instance = planets[planet_number].instance()
	
	instance.global_position = $Player/Path2D/PathFollow2D/Position2D.global_position
	add_child(instance)
