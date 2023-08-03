extends Sprite

onready var branchName = self.name
onready var unlockedColor = Color(1, 0.764706, 0.207843)
onready var lockedColor = Color(0, 0, 0)

var otherBranches = {
	'directional1' : ['directional1', 'mainleftdirectional1', 'tracerLook', 'mainleft2','leftAngle'],
	'look' : ['look', 'leftAngle', 'mainleft2', 'tracerLook'],
	'tracerBullet' : ['tracerBullet', 'rightAngle', 'mainRight'],
	'boost': ['boost', 'leftAngle', 'mainleft2'],
	'explosiveBullet': ['rightAngle', 'mainRight', 'boostToExplosion', 'explosiveBullet'],
	'autoAim1': ['rightAngle', 'mainRight', 'boostToExplosion', 'autoAim1', 'autoAim1Branch'],
}
var branchFolders = ['autoAim1', 'directional1', 'look', 'tracerBullet', 'boost', 'explosiveBullet']

func _ready():
	var skillTree = get_tree().get_root().find_node('SkillTree', true, false)
	skillTree.connect("changeBranchColor", self, 'changeOwnColor')

func changeOwnColor(target):
	for item in Global.unlockedSkills:
		if mainBranches(target):
			for branch in otherBranches[target]:
				if branch == branchName:
					self.self_modulate = unlockedColor
		elif self.name == item:
			self.self_modulate = unlockedColor

func mainBranches(target):
	for sprite in branchFolders:
		if sprite == target:
			return true
	return false
