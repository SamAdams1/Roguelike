extends ColorRect

var mouseOver = false
var item = null
onready var player = get_tree().current_scene.get_node('Player')

signal selectedUpgrade(upgrade)

#func _ready():
#	player.upgradePlayer()
#	connect("selectedUpgrade", Callable(player, "upgradePlayer"))

func _input(event):
	if event.is_action_pressed('click') and mouseOver:
		emit_signal('selectedUpgrade', item)
		player.upgradePlayer()

func _on_ItemOption_mouse_entered():
	mouseOver = true


func _on_ItemOption_mouse_exited():
	mouseOver = false
