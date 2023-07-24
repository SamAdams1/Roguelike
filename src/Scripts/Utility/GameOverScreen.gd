extends Node2D


export var mainGameScene : PackedScene
export var mainMenu : PackedScene
onready var music = $music

func _ready():
	music.play()

func _on_NewGameButton_pressed():
	get_tree().change_scene(mainGameScene.resource_path)


func _on_mainMenuButton_pressed():
	get_tree().change_scene(mainMenu.resource_path)


func _on_quitButton_pressed():
	 get_tree().quit()
