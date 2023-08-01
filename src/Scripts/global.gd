extends Node

var node_creation_parent = null
var trackingMissleTarget = null
var closeEnemies = []
var nearestEnemy = null

var points = 0




#Skill Tree
#onready var turretIdentifiers = ['turret', 'barrel2', 'barrel3', 'barrel4', 'bigBullet', 'bigBullet2Direction', 
#'bigBullet2Barrel', '2direction', '3direction', '4direction']

var unlockedSkills = ['first',  'turret']
#var unlockedSkills = ['first',  'turret', 'bigBullet', 'bigBullet2Direction']
#var unlockedSkills = ['first',  'turret', 'barrel2', 'barrel3', 'barrel4']
#var unlockedSkills = ['first',  'turret', '2direction', '3direction', '4direction']

var selectedButton = null
var skillUnlockPoints = 0

func instance_node(node, location, parent):
	var node_instance = node.instance()
	parent.add_child(node_instance)
	node_instance.global_position = location
	return node_instance
