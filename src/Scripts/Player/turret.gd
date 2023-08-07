extends Node2D
#attacking
onready var bullet = preload('res://Scenes/bullet.tscn')
onready var bigBullet = preload("res://Scenes/bigBullet.tscn")
onready var sound = $turretShootSound
var waitToFire = false
var toggleFire = false
var fireRate =  Global.fireRate
var bulletSpeed = Global.bulletSpeed
var currentTurret = null


#turret bullet spawn points
onready var bulletSpawnPoints = {
	'turret' : [$turret/point1],
	'barrel2': [$barrel2/point1,$barrel2/point2],
	'barrel3': [$barrel3/point1, $barrel3/point2, $barrel3/point3],
	'barrel4': [$barrel4/point1, $barrel4/point2, $barrel4/point3, $barrel4/point4],
	'bigBullet': [$bigBullet/point1],
	'bigBullet2Direction': [$bigBullet2Direction/point1, $bigBullet2Direction/point2Back],
	'bigBullet2Barrel': [$bigBullet2Barrel/point1, $bigBullet2Barrel/point2],
	'2direction': [$"2direction/point1", $"2direction/point2Back"],
	'3direction': [$"3direction/point1", $"3direction/point3Left", $"3direction/point4Right"],
	'4direction': [$"4direction/point1", $"4direction/point2Back", $"4direction/point3Left", $"4direction/point4Right"],
}

onready var turretIdentifiers = ['turret', 'barrel2', 'barrel3', 'barrel4', 'bigBullet', 'bigBullet2Direction', 
'bigBullet2Barrel', '2direction', '3direction', '4direction']

func _ready():
	var skillTree = get_tree().get_root().find_node('SkillTree', true, false)
	skillTree.connect("setPlayerTurret", self, 'upgradeTurret')
	for skill in Global.unlockedSkills:
		for turret in turretIdentifiers:
			if skill == turret:
				currentTurret = skill
				self.get_node(currentTurret).visible = true
		

func _physics_process(_delta):
	look_at(get_global_mouse_position())
#	if get_tree().paused == true:
#		toggleFire = false
	

func _input(event): #shooting has to be in here so only one input is taken per mouse click
	if event.is_action_pressed("attack"):
		toggleFire = !toggleFire
		
	while toggleFire and !waitToFire and currentTurret != null and get_tree().paused == false:
		waitToFire = true
		sound.play()
		turretFireProcess()
		yield(get_tree().create_timer(fireRate), "timeout")
		waitToFire = false

func fire(spawnPoint, direction, typeOfBullet): #creates bullet
	var bullet_instance = typeOfBullet.instance()
	bullet_instance.position = spawnPoint.get_global_position()
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.apply_impulse(Vector2(), Vector2(bulletSpeed * direction, 0).rotated(rotation))
	get_tree().get_root().call_deferred("add_child", bullet_instance)

func fire2(spawnPoint, direction, spin): #creates bullet
	var bullet_instance = bullet.instance()
	bullet_instance.position = spawnPoint.get_global_position()
	bullet_instance.rotation_degrees = rotation_degrees + spin
	bullet_instance.apply_impulse(Vector2(), Vector2(bulletSpeed, 0).rotated(rotation + direction))
	get_tree().get_root().call_deferred("add_child", bullet_instance)

func upgradeTurret(target):
	if currentTurret != null:
		self.get_node(currentTurret).visible = false
	currentTurret = target
	self.get_node(currentTurret).visible = true

func turretFireProcess():
#	print('+++++++++++')
	for spawnPoint in bulletSpawnPoints[currentTurret]:
#		print(spawnPoint, '|||', spawnPoint.name == "point2Back")
		if spawnPoint.get_parent().name.get_slice("2", 0) == 'bigBullet':
			if spawnPoint.name == "point2Back":
				fire(spawnPoint, -1, bigBullet)
			else:
				fire(spawnPoint, 1, bigBullet)
			
		elif spawnPoint.name == "point2Back":
			fire(spawnPoint, -1, bullet)
#			
		elif spawnPoint.name == 'point3Left':
			fire2(spawnPoint, 55, -90)
#			
		elif spawnPoint.name == 'point4Right':
			fire2(spawnPoint, -55, 90)
		
		else:
			fire(spawnPoint, 1, bullet)

func setStats():
	fireRate =  Global.fireRate
	bulletSpeed = Global.bulletSpeed

