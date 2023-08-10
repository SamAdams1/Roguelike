extends Control

const ITEMS ={
	'statPointButton':{
		'cost': 100,
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
		'cost': 50,
		'desc': "I'll paint your ship figgleslorp green.",
	},
	'color2':{
		'cost': 50,
		'desc': "Supposedly that is the color of the oceans, I wouldn't know. I've never seen an ocean!",
	},
	'color3':{
		'cost': 50,
		'desc': "I'll change your ship back to its original blazing red!",
	},
	'colorPurchased':{
		'cost':50,
		'desc': "Sorry partner, I don't have enough paint for them turrets on the bottom. I'll give you a slight refund to make up for it!"
	}
}

onready var player = get_tree().current_scene.get_node('Player')
onready var store = get_tree().current_scene.get_node('Store')

onready var playerWalletLabel = $walletAmount
onready var playerMoney = player.money
#onready var playerMoney = 100
onready var costLabel = $costLabel
onready var desc = $desc

onready var colorLastPurchased = false

var itemCost = 0
var target = null
var lastButton = null

func _ready():
	playerMoney += 0

func _physics_process(_delta):
	if self.visible == true:
		playerMoney = player.money
		playerWalletLabel.text = str(playerMoney)
		if get_focus_owner() != null:
			buttonToggle()
			target = str(get_focus_owner()).get_slice(":", 0)
			if target != 'color1' and target != 'color2' and target != 'color3':
				colorLastPurchased = false
			
			if !colorLastPurchased:
				itemCost = ITEMS[target]['cost']
				costLabel.text = 'Cost: ' + str(itemCost)
				desc.text = str(ITEMS[target]['desc'])

var buttonList = []
func buttonToggle():
	var buttonPressed = get_focus_owner()
	if !buttonList.has(buttonPressed):
		buttonList.append(buttonPressed)
		buttonPressed.get('custom_styles/normal/bg_color').bg_color  = Color(0.207843, 0.023529, 0.721569)
	if buttonList.size() >= 2:
		var lastButton = buttonList.pop_front()
		lastButton.get('custom_styles/normal/bg_color').bg_color  = Color(0.254902, 0.023529, 0.890196)

func _on_purchaseButton_pressed():
	if target != null and itemCost <= playerMoney:
		player.money -= itemCost 
		applyPurchases()
		if target == 'color1' or target == 'color2' or target == 'color3':
			colorLastPurchased = true
			costLabel.text = 'Cost: ' + str(ITEMS['colorPurchased']['cost'])
			desc.text = str(ITEMS['colorPurchased']['desc'])

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
	player.moneyLabel.text = str(player.money)
	if str(get_tree().current_scene).get_slice(":", 0) == 'Main':
		self.visible = false
		get_tree().paused = false
		yield(get_tree().create_timer(1), "timeout")
		Global.store.queue_free()
	else:
		get_tree().quit()
