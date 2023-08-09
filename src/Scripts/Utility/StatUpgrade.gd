extends ColorRect

onready var statPoints = 0
onready var tracerBulletUnlocked = false
onready var boostUnlocked = false
onready var pointsLabel = $points
onready var warningLabel  = $warning
var target = null
var value = null

onready var player = get_tree().current_scene.get_node('Player')
onready var turret = get_tree().get_root().find_node('turret', true, false)
onready var skillTree = get_tree().get_root().find_node('SkillTree', true, false)

signal setKnockBack


#signal upgradeStats

const VALUES = {
	'playerMovementSpeed':  25,
	'boostValue': 25,
	'boostCapacity': 0.9,
	'maxHealth': 2,
	'fireRate': 0.1,
	'knockback': 1,
	'bulletHealth': 1,
	'bulletDamage': .5,
	'bulletSpeed': 100,
}
func _ready():
	pointsLabel.text = 'x' + str(statPoints)
	warningLabel.visible = false



func _physics_process(_delta):
	if get_tree().paused == true:
		updatePoints()

func _on_button_pressed():
	if skillTree.visible == false:
		target = str(get_focus_owner()).get_slice(":", 0)
		value = VALUES[target]
		if target == 'bulletHealth' and tracerBulletUnlocked:
			warningLabel.visible = true
			warningLabel.text = 'Cannot upgrade with Tracer Bullet Unlocked'
			return
		if (target == 'boostCapacity' or target == 'boostValue') and !boostUnlocked:
			warningLabel.visible = true
			warningLabel.text = 'Unlock Boost Skill'
			return
		warningLabel.visible = false
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
		
	elif target == 'bulletHealth' and !tracerBulletUnlocked:
		Global.bulletHealth += value
		
	elif target == 'knockback':
		Global.knockback += value
		emit_signal("setKnockBack")
		
	elif target == 'fireRate':
		Global.fireRate -= value
		
	elif target == 'maxHealth':
		Global.playerHealth += value
		
	elif target == 'boostCapacity' and boostUnlocked:
		Global.boostCapacity += value
		
	elif target == 'boostValue' and boostUnlocked:
		Global.boostValue += value
		
	elif target == 'playerMovementSpeed':
		Global.playerMovementSpeed += value
	player.setStats()
	turret.setStats()


func updatePoints():
	pointsLabel.text = 'x' + str(statPoints)

func tracerBulletandBoost(item):
	if item == 'boost':
		boostUnlocked = true
	elif item == 'tracerBullet':
		tracerBulletUnlocked = true
		statPoints += $bulletPenetration/TextureProgress.value
		$bulletPenetration/TextureProgress.value = 0
