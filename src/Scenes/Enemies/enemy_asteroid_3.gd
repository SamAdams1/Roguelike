extends "res://Scripts/EnemyScripts/enemy_core.gd"


func _process(delta):
	basic_movement_towards_player(delta)



func _on_AudioStreamPlayer_finished():
	queue_free()


