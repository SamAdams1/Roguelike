extends Node2D


export var mainGameScene : PackedScene

onready var options_menu = $OptionsMenu
onready var music = $MenuMusic

#func _ready():
#	music.play()

func _on_NewGameButton_pressed():
	get_tree().change_scene(mainGameScene.resource_path)


func _on_OptionsButton_pressed():
	options_menu.popup_centered()
