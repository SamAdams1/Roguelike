extends ColorRect

onready var statPoints = 2
onready var homingBulletUnlocked = false
onready var pointsLabel = $points
var target = null
var value = null

onready var player = get_tree().current_scene.get_node('Player')
onready var turret = get_tree().get_root().find_node('turret', true, false)


#signal upgradeStats

const VALUES = {
	'playerMovementSpeed':  25,
	'boostValue': 25,
	'boostCapacity': 0.9,
	'maxHealth': 2,
	'fireRate': 0.1,
	'knockback': 5,
	'bulletHealth': 1,
	'bulletDamage': 1,
	'bulletSpeed': 100,
}
func _ready():
	pointsLabel.text = 'x' + str(statPoints)
	


func _physics_process(_delta):
	if get_tree().paused == true:
		
		if homingBulletUnlocked:
			pass

func _on_button_pressed():
	target = str(get_focus_owner()).get_slice(":", 0)
	value = VALUES[target]
	increaseBar()
	upgradeStat()
	if statPoints == 0:
		yield(get_tree().create_timer(0.25), "timeout")
		player.upgradePlayer()

func increaseBar():
	var progressBar = get_node(get_focus_owner().get_parent().name + '/' +  'TextureProgress')
	if statPoints > 0 and progressBar.value < progressBar.max_value:
		progressBar.value += 1
		statPoints -= 1


func upgradeStat():
	if target == 'bulletSpeed':
		Global.bulletSpeed += value
		
	elif target == 'bulletDamage':
		Global.bulletDamageMultiplier += value
		
	elif target == 'bulletHealth':
		Global.bulletHealth += value
		
	elif target == 'knockback':
		Global.knockback += value
		
	elif target == 'fireRate':
		Global.fireRate -= value
		
	elif target == 'maxHealth':
		Global.playerHealth += value
		
	elif target == 'boostCapacity':
		Global.boostCapacity += value
		
	elif target == 'boostValue':
		Global.boostValue += value
		
	elif target == 'playerMovementSpeed':
		Global.playerMovementSpeed += value
	player.setStats()
	turret.setStats()


func updatePoints():
	pointsLabel.text = 'x' + str(statPoints)
