extends Node2D


export var mainGameScene : PackedScene
onready var music = $MenuMusic

#func _ready():
#	music.play()

func _on_NewGameButton_pressed():
	get_tree().change_scene(mainGameScene.resource_path)
