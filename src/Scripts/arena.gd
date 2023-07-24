extends Node

export(Array, PackedScene) var enemies
onready var music = $music

func _ready():
	music.play()
	randomize()
	Global.points = 0

func _on_enemy_spawn_timer_timeout():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var enemy_number = round(rand_range(0, enemies.size() - 1))
	
	$Player/Path2D/PathFollow2D.offset = rng.randi_range(0, 3300)
	var instance = enemies[enemy_number].instance()
	
	instance.global_position = $Player/Path2D/PathFollow2D/Position2D.global_position
	add_child(instance)
	
func _on_difficulty_timer_timeout():
	if $enemy_spawn_timer.wait_time > 0.5:
		$enemy_spawn_timer.wait_time -= 0.1
