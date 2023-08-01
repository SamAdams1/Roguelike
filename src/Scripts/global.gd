extends Node

var node_creation_parent = null
var trackingMissleTarget = null
var closeEnemies = []
var nearestEnemy = null

var points = 0

#Skill Tree
var unlockedSkills = ['first', 'turret']
var selectedButton = null
var skillUnlockPoints = 0

func instance_node(node, location, parent):
	var node_instance = node.instance()
	parent.add_child(node_instance)
	node_instance.global_position = location
	return node_instance
