extends Control

onready var selectionDetails = $selection
onready var title = $selection/title
onready var description = $selection/description
onready var selectButton = $selectSkillButton
onready var branchLines = preload("res://Scripts/Utility/skillTreeLines.gd")
onready var cancelOrConfirmButtons = $confirmOrCancel
onready var exitLabel = $exitButton/exitLabel
onready var exitButton = $exitButton
onready var pointLabel =$header/pointsLabel
onready var headerLabel = $header/headerLabel
onready var levelLabel = $header/playerLevel
onready var costLabel = $selection/cost

onready var player = get_tree().current_scene.get_node('Player')
onready var statUpgrade = get_tree().get_root().find_node('StatUpgrade', true, false)
var target = null
var points = 0
var skillCost = 1
var level = 0

signal changeBranchColor
signal setPlayerTurret
signal upgradePlayer

const SKILLS = {
	'turret': {
		'category': 'turret',
		'title': 'Turret',
		'desc': 'Toggle shoots at mouse position.',
		'prerequiste': ['first'],
		'nonrequiste': [''],
		'cost': 1,
	},
	'barrel2': {
		'category': 'turret',
		'title': 'Double Barrel',
		'desc': 'Shoot 2 bullets.',
		'prerequiste': ['turret',],
		'nonrequiste': ['bigBullet', '2direction'],
		'cost': 1,
	},
	'barrel3':{
		'category': 'turret',
		'title': "Triple Barrel",
		'desc': "Shoots 3 bullets.",
		'prerequiste': ['turret', 'barrel2'],
		'nonrequiste': ['bigBullet', '2direction'],
		'cost': 2,
	},
	'barrel4': {
		'category': 'turret',
		'title': 'Quad Barrel',
		'desc': "Shoots 4 Bullets.",
		'prerequiste': ['turret', 'barrel2', 'barrel3'],
		'nonrequiste': ['bigBullet', '2direction'],
		'cost': 3,
	},
	'bigBullet': {
		'category': 'turret',
		'title': 'Big Turret',
		'desc': "Shoots a big bullet that does 2x more damage.",
		'prerequiste': ['turret'],
		'nonrequiste': ['barrel2', '2direction'],
		'cost': 1,
	},
	'bigBullet2Barrel': {
		'category': 'turret',
		'title': 'Double Big Barrels',
		'desc': "Shoots two big bullets side by side.",
		'prerequiste': ['turret', 'bigBullet'],
		'nonrequiste': ['barrel2', '2direction'],
		'cost': 2,
	},
	'bigBullet2Direction': {
		'category': 'turret',
		'title': '2-D Big Turret',
		'desc': "Shoots big bullets from the front and the back.",
		'prerequiste': ['turret', 'bigBullet'],
		'nonrequiste': ['barrel2', '2direction'],
		'cost': 2,
	},
	'2direction': {
		'category': 'turret',
		'title': '2-D Turret',
		'desc': "Shoots in 2 separate directions.",
		'prerequiste': ['turret'],
		'nonrequiste': ['barrel2', 'bigBullet'],
		'cost': 1,
	},
	'3direction': {
		'category': 'turret',
		'title': '3-D Turret',
		'desc': "Shoots in 3 separate directions.",
		'prerequiste': ['turret','2direction'],
		'nonrequiste': ['barrel2', 'bigBullet'],
		'cost': 2,
	},
	'4direction': {
		'category': 'turret',
		'title': '4-D Turret',
		'desc': "Shoots in 4 separate directions.",
		'prerequiste': ['turret','2direction', '3direction'],
		'nonrequiste': ['barrel2', 'bigBullet'],
		'cost': 3,
	},
	'autoAim1': {
		'category': 'autoaim',
		'title': 'Auto Aim Turret',
		'desc': "Shoots at the nearest enemy.",
		'prerequiste': ['first'],
		'cost': 1,
	},
	'autoAim2': {
		'category': 'autoaim',
		'title': 'Auto-Aim Turret 2',
		'desc': "Shoots 2 bullets at the nearest enemy in rapid succesion.",
		'prerequiste': ['autoAim1'],
		'cost': 2,
	},
	'autoAim3': {
		'category': 'autoaim',
		'title': 'Auto-Aim Turret 3',
		'desc': "Shoots 3 bullets at the nearest enemy in rapid succesion.",
		'prerequiste': ['autoAim1', 'autoAim2'],
		'cost': 3,
	},
	'directional1': {
		'category': 'directional',
		'title': '1st Ship Gun',
		'desc': "Shoots a bullet in the direction your ship is facing.",
		'prerequiste': ['first'],
		'cost': 1,
	},
	'directional2': {
		'category': 'directional',
		'title': '2nd Ship Gun',
		'desc': "Shoots 2 bullets in the direction your ship is facing.",
		'prerequiste': ['directional1'],
		'cost': 2,
	},
	'directional3': {
		'category': 'directional',
		'title': '3rd Ship Gun',
		'desc': "Shoots 3 bullets in the direction your ship is facing.",
		'prerequiste': ['directional1', 'directional2'],
		'cost': 3,
	},
	'tracerBullet': {
		'category': 'other',
		'title': 'Tracer Bullets',
		'desc': "Bullets will lock on to an enemy in front of it. Refunds points spent on bullet penetration.",
		'prerequiste': ['first'],
		'cost': 1,
	},
	'look': {
		'category': 'other',
		'title': 'Look',
		'desc': "Press alt/shift with WASD to turn your ship with out moving.",
		'prerequiste': ['first'],
		'cost': 1,
	},
	'explosiveBullet': {
		'category': 'other',
		'title': 'Explosive Bullets',
		'desc': "Bullets explode on impact, dealing a wider range of damage.",
		'prerequiste': ['first'],
		'cost': 3,
	},
	'boost': {
		'category': 'other',
		'title': 'Boost',
		'desc': "Press space to go into hyperdrive.",
		'prerequiste': ['first'],
		'cost': 1,
	},
}
func _physics_process(_delta):
	if self.visible == true and points > 1:
		exitLabel.text  = 'Exit and Save Points'
	

func _ready():
	if str(get_tree().current_scene).get_slice(":", 0) == 'Main':
		player.connect('firstLevel', self, 'hideOther')
	if points > 1:
		exitLabel.text  = 'Exit and Save Points'

	pointLabel.text = 'x' + str(points)
	
	selectionDetails.visible = true
	selectButton.visible = true
	exitButton.visible = false
	cancelOrConfirmButtons.visible = false
	emit_signal("changeBranchColor", target)

func _on_Button_pressed():
	target = str(get_focus_owner()).get_slice(":", 0)
	Global.selectedButton = target
	changeLabels()

func _on_selectSkillButton_pressed():
	if target != null and targetNotUnlocked():
		var list = [true]
		var prereq = checkPrereqs()
		
		for skill in Global.unlockedSkills:
			if SKILLS[target]['category'] == 'turret':
				for cant in SKILLS[target]["nonrequiste"]:
					list.append(cant != skill)
		
		if checkAllTrue(list) and checkTotalCost():
			if prereq:
				unlockSkill(target)
				stopStatUpgrades()
				exitButton.visible = true
			elif !prereq:
				for requisite in SKILLS[target]["prerequiste"]:
					if Global.unlockedSkills.count(requisite) == 0:
						unlockSkill(requisite)
				unlockSkill(target)
				exitButton.visible = true
			else:
				pointLabelBlink()
		else:
			pointLabelBlink()
	else:
		pointLabelBlink()


func pointLabelBlink():
	for i in range(0,2):
			pointLabel.self_modulate = Color(0.984314, 0.043137, 0.043137)
			yield(get_tree().create_timer(0.3), "timeout")
			pointLabel.self_modulate = Color(1, 1, 1)
			yield(get_tree().create_timer(0.3), "timeout")

func targetNotUnlocked():
	for skill in Global.unlockedSkills:
		if target == skill:
			return false
	return true

func checkAllTrue(list):
	for item in list:
		if item == false:
			return false
	return true
	
func checkPrereqs():
	var prereqList = []
	for prereq in SKILLS[target]["prerequiste"]:
		for unlockedSkill in Global.unlockedSkills:
			if prereq == unlockedSkill:
				prereqList.append(prereq)
	return prereqList.size() == SKILLS[target]["prerequiste"].size()

func unlockSkill(upgrade):
	Global.unlockedSkills.append(upgrade)
	points -= SKILLS[upgrade]["cost"]
	emit_signal("changeBranchColor", upgrade)
	pointLabel.text = 'x' + str(points)
	if points <= 0:
		exitLabel.text = 'Exit'
	setTurret()

func setTurret():
	if SKILLS[target]['category'] == 'turret':
		emit_signal('setPlayerTurret', target)
	else:
		emit_signal("upgradePlayer", target, SKILLS[target]['category'])

func changeLabels():
	selectionDetails.visible = true
	selectButton.visible = true
	title.text = str(SKILLS[target]['title'])
	description.text = str(SKILLS[target]['desc'])
	if str(SKILLS[target]['cost']) == '1':
		costLabel.text = str(SKILLS[target]['cost']) + " Unlock Point"
	else:
		costLabel.text = str(SKILLS[target]['cost']) + " Unlock Points"

func updatePoints():
	pointLabel.text = 'x' + str(points)

func _on_exitAndSaveButton_pressed():
	if points > 0:
		cancelOrConfirmButtons.visible = true
	elif str(get_tree().current_scene).get_slice(":", 0) == 'Main':
#		player.upgradePlayer()
		self.visible = false
	elif str(get_tree().current_scene).get_slice(":", 0) == 'SkillTree':
		get_tree().quit()

func _on_confirmButton_pressed():
	cancelOrConfirmButtons.visible = false
	if str(get_tree().current_scene).get_slice(":", 0) == 'Main':
		self.visible = false
	elif str(get_tree().current_scene).get_slice(":", 0) == 'SkillTree':
		get_tree().quit()

func _on_cancelButton_pressed():
	cancelOrConfirmButtons.visible = false


var other = ['treeLines/look', 'treeLines/tracerBullet', 'treeLines/boost', 'treeLines/explosiveBullet', 'Other']

func hideOther(playerLevel):
	level = playerLevel
	for i in other:
		if playerLevel == 1:
			headerLabel.text = "Choose Your Weapon"
			get_node(i).visible = false
		else:
			headerLabel.text = "Level Up !" 
			levelLabel.text = 'Level: ' + str(playerLevel)
			get_node(i).visible = true

func checkTotalCost():
	var cost = SKILLS[target]["cost"]
	for prereq in SKILLS[target]["prerequiste"]:
		if !Global.unlockedSkills.has(prereq):
			cost += SKILLS[prereq]["cost"]
	print(cost)
	return cost <= points

func stopStatUpgrades():
	statUpgrade.tracerBulletandBoost(target)
