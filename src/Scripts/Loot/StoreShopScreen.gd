extends Control

const ITEMS ={
	'statPointButton':{
		'cost': 150,
		'desc': "In need of an extra stat point are you?",
	},
	'skillPointButton':{
		'cost': 150,
		'desc': "If you buy this you can upgrade your ship some more!",
	},
	'healthButton':{
		'cost': 50,
		'desc': "In need of some health, ey partner?",
	},
	'killEnemiesButton':{
		'cost': 300,
		'desc': "Whew there sure are a lot of them out there, sure I don't mind helpin' a friend. But it'll cost you.",
	},
	'color1':{
		'cost': 25,
		'desc': "I'll paint your ship a beautiful green.",
	},
	'color2':{
		'cost': 25,
		'desc': "Ah that one will ",
	},
	'color3':{
		'cost': 25,
		'desc': "Ah that one will ",
	},
}

onready var player = get_tree().current_scene.get_node('Player')
onready var store = get_tree().current_scene.get_node('Store')

onready var playerWalletLabel = $walletAmount
onready var playerMoney = player.money
#onready var playerMoney = 100
onready var costLabel = $costLabel
onready var desc = $desc


var itemCost = 0
var target = null

func _ready():
	playerMoney += 1000

func _physics_process(_delta):
	playerWalletLabel.text = str(playerMoney)
	if self.visible == true and get_focus_owner() != null:
		target = str(get_focus_owner()).get_slice(":", 0)
		itemCost = ITEMS[target]['cost']
		costLabel.text = 'Cost: ' + str(itemCost)
		desc.text = str(ITEMS[target]['desc'])


func _on_purchaseButton_pressed():
	if target != null and itemCost <= playerMoney:
		playerMoney -= itemCost 
		applyPurchases()

func applyPurchases():
	if target == 'statPointButton':
		player.statUpgrade.statPoints += 1
	elif target == 'skillPointButton':
		player.skillTree.points += 1
	elif target == 'healthButton':
		Global.store.spawnHealth(2)
	elif target == 'killEnemiesButton':
		Global.store.killEnemies()
	else:
		player.changeShipColor(int(target.get_slice("color", 1)))

func _on_leaveButton_pressed():
	if str(get_tree().current_scene).get_slice(":", 0) == 'Main':
		self.visible = false
		get_tree().paused = false
		yield(get_tree().create_timer(1), "timeout")
		Global.store.queue_free()
	else:
		get_tree().quit()
