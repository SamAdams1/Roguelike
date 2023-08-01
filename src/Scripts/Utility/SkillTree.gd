extends Control

onready var selectionDetails = $selection
onready var title = $selection/title
onready var description = $selection/description
onready var selectButton = $selectSkillButton
onready var branchLines = preload("res://Scripts/Utility/skillTreeLines.gd")
onready var cancelOrConfirmButtons = $confirmOrCancel
onready var exitLabel = $exitAndSaveButton/exitLabel
onready var pointLabel =$LevelUpPanel/pointsLabel

onready var player = get_tree().current_scene.get_node('Player')
var target = null
var points = 1
var skillCost = 1

signal changeBranchColor
signal setPlayerTurret
signal upgradePlayer

const SKILLS = {
	'turret': {
		'category': 'turret',
		'title': 'Turret',
		'desc': 'Toggle shoots at mouse position.',
		'prerequiste': 'first',
		'nonrequiste': [''],
	},
	'barrel2': {
		'category': 'turret',
		'title': 'Double Barrel',
		'desc': 'Shoot 2 bullets.',
		'prerequiste': 'turret',
		'nonrequiste': ['bigBullet', '2direction'],
	},
	'barrel3':{
		'category': 'turret',
		'title': "Triple Barrel",
		'desc': "Shoots 3 bullets.",
		'prerequiste': 'barrel2',
		'nonrequiste': ['bigBullet', '2direction'],
	},
	'barrel4': {
		'category': 'turret',
		'title': 'Quad Barrel',
		'desc': "Shoots 4 Bullets.",
		'prerequiste': 'barrel3',
		'nonrequiste': ['bigBullet', '2direction'],
	},
	'bigBullet': {
		'category': 'turret',
		'title': 'Big Turret',
		'desc': "Shoots a big bullet that does 2x more damage.",
		'prerequiste': 'turret',
		'nonrequiste': ['barrel2', '2direction'],
	},
	'bigBullet2Barrel': {
		'category': 'turret',
		'title': 'Double Big Barrels',
		'desc': "Shoots two big bullets side by side.",
		'prerequiste': 'bigBullet',
		'nonrequiste': ['barrel2', '2direction'],
	},
	'bigBullet2Direction': {
		'category': 'turret',
		'title': '2-D Big Turret',
		'desc': "Shoots big bullets from the front and the back.",
		'prerequiste': 'bigBullet',
		'nonrequiste': ['barrel2', '2direction'],
	},
	'2direction': {
		'category': 'turret',
		'title': '2-D Turret',
		'desc': "Shoots in 2 separate directions.",
		'prerequiste': 'turret',
		'nonrequiste': ['barrel2', 'bigBullet'],
	},
	'3direction': {
		'category': 'turret',
		'title': '3-D Turret',
		'desc': "Shoots in 3 separate directions.",
		'prerequiste': '2direction',
		'nonrequiste': ['barrel2', 'bigBullet'],
	},
	'4direction': {
		'category': 'turret',
		'title': '4-D Turret',
		'desc': "Shoots in 4 separate directions.",
		'prerequiste': '3direction',
		'nonrequiste': ['barrel2', 'bigBullet'],
	},
	'autoAim1': {
		'category': 'autoaim',
		'title': 'Auto Aim    Turret',
		'desc': "Shoots at the nearest enemy.",
		'prerequiste': 'first',
	},
	'autoAim2': {
		'category': 'autoaim',
		'title': 'Auto-Aim    Turret 2',
		'desc': "Shoots 2 bullets at the nearest enemy in rapid succesion.",
		'prerequiste': 'autoAim1',
	},
	'autoAim3': {
		'category': 'autoaim',
		'title': 'Auto-Aim    Turret 3',
		'desc': "Shoots 3 bullets at the nearest enemy in rapid succesion.",
		'prerequiste': 'autoAim2',
	},
	'directional1': {
		'category': 'directional',
		'title': '1st Ship Gun',
		'desc': "Shoots a bullet in the direction your ship is facing.",
		'prerequiste': 'first',
	},
	'directional2': {
		'category': 'directional',
		'title': '2nd Ship Gun',
		'desc': "Shoots 2 bullets in the direction your ship is facing.",
		'prerequiste': 'directional1',
	},
	'directional3': {
		'category': 'directional',
		'title': '3rd Ship Gun',
		'desc': "Shoots 3 bullets in the direction your ship is facing.",
		'prerequiste': 'directional2',
	},
	'tracerBullet': {
		'category': 'other',
		'title': 'Tracer Bullets',
		'desc': "Bullets will lock on to any enemies in front of it.",
		'prerequiste': 'first',
	},
	'look': {
		'category': 'other',
		'title': 'Look',
		'desc': "Press alt/shift with WASD to turn your ship with out moving.",
		'prerequiste': 'first',
	},
	'explosiveBullet': {
		'category': 'other',
		'title': 'Explosive Bullets',
		'desc': "Bullets explode on impact, dealing a wider range of damage.",
		'prerequiste': 'first',
	},
	'boost': {
		'category': 'other',
		'title': 'Boost',
		'desc': "Press space to go into hyperdrive.",
		'prerequiste': 'first',
	},
}

func _ready():
	Global.skillUnlockPoints += 20
	points = Global.skillUnlockPoints
	pointLabel.text = 'x' + str(points)
	
	selectionDetails.visible = false
	selectButton.visible = true
	cancelOrConfirmButtons.visible = false
	emit_signal("changeBranchColor", target)

func _on_Button_pressed():
	target = str(get_focus_owner()).get_slice(":", 0)
	Global.selectedButton = target
	changeLabels()

func _on_selectSkillButton_pressed():
	if points >= 1 and target != null:
		var list = []
		var prereq = false
		for skill in Global.unlockedSkills:
			if SKILLS[target]['category'] == 'turret':
				for cant in SKILLS[target]["nonrequiste"]:
					list.append(cant != skill)
			if skill == SKILLS[target]["prerequiste"]:
				prereq = true
					
		if prereq and checkAllTrue(list):
			Global.unlockedSkills.append(target)
			points -= skillCost
			emit_signal("changeBranchColor", target)
			pointLabel.text = 'x' + str(points)
			if points <= 0:
				exitLabel.text = 'Exit'
			setTurret()
			
	else:
		pass #add labels that tell why they cant buy the upgrade

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

func updatePoints():
	pointLabel.text = 'x' + str(points)

func checkAllTrue(list):
	for item in list:
		if item == false:
			return false
	return true

func _on_exitAndSaveButton_pressed():
	if points > 0:
		cancelOrConfirmButtons.visible = true
	elif str(get_tree().current_scene).get_slice(":", 0) == 'Main':
		player.upgradePlayer()

func _on_confirmButton_pressed():
	cancelOrConfirmButtons.visible = false
	if str(get_tree().current_scene).get_slice(":", 0) == 'Main':
		player.upgradePlayer()

func _on_cancelButton_pressed():
	cancelOrConfirmButtons.visible = false












