extends Node

var node_creation_parent = null

#autoAim
var closeEnemies = []
var nearestEnemy = null

#enemys killed
var points = 0

# upgradable stats
var fireRate = 1
var bulletSpeed = 500
var bulletHealth = 1
var bulletDamageMultiplier = 0
var knockback = 0
var knockbackUnlocked = false

var playerMovementSpeed = 300
var playerHealth = 10
var boostCapacity = 2
var boostValue = 100

#skills
var unlockedSkills = ['first', ]
#var unlockedSkills = ['first',  'turret', 'bigBullet', 'bigBullet2Direction']
#var unlockedSkills = ['first',  'turret', 'barrel2', 'barrel3', 'barrel4']
#var unlockedSkills = ['first',  'turret', '2direction', '3direction', '4direction']

var selectedButton = null
#var skillUnlockPoints = 0

#store
var store = null

func instance_node(node, location, parent):
	var node_instance = node.instance()
	parent.add_child(node_instance)
	node_instance.global_position = location
	return node_instance
