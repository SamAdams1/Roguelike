extends Node2D


export var mainGameScene : PackedScene


func _on_NewGameButton_pressed():
	get_tree().change_scene(mainGameScene.resource_path)
