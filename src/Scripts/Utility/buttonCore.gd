extends Button
onready var buttonName = self.name
onready var unlockedNormalColor = Color(0.976471, 0.768627, 0.215686)
onready var unlockedHoverColor = Color(0.984314, 0.819608, 0.388235)
onready var unlockedPressedColor = Color(0.84375, 0.663665, 0.18457)

onready var hoverColor = Color(0.415686, 0.262745, 0.670588)
onready var hoverColor2 = Color(0.478431, 0.164706, 0.996078)
onready var hoverColor3 = Color(0.278431, 0.015686, 1)

onready var pressedColor = Color(0.247059, 0.019608, 0.443137)

onready var normalColor = Color(0.360784, 0.223529, 0.584314)
onready var normalColor2 = Color(0.396078, 0.109804, 0.862745)
onready var normalColor3 = Color(0.254902, 0.023529, 0.890196)

var unlockedSkills = Global.unlockedSkills
var buttonUnlocked = false 
onready var cost = self.get_parent().get_parent().SKILLS[buttonName]['cost']

func _ready():
	if buttonName in Global.unlockedSkills:
		changeColor(unlockedNormalColor, unlockedHoverColor, unlockedPressedColor)
	if cost == 1:
		self.get('custom_styles/hover/bg_color').bg_color = hoverColor
	if cost == 2:
		self.get('custom_styles/hover/bg_color').bg_color = hoverColor2
	if cost == 3:
		self.get('custom_styles/hover/bg_color').bg_color = hoverColor3

func _process(_delta):
	
	if buttonName != Global.selectedButton and !buttonUnlocked and cost == 1:
		self.get('custom_styles/normal/bg_color').bg_color = normalColor
	elif buttonName != Global.selectedButton and !buttonUnlocked and cost == 2:
		self.get('custom_styles/normal/bg_color').bg_color = normalColor2
	elif buttonName != Global.selectedButton and !buttonUnlocked and cost == 3:
		self.get('custom_styles/normal/bg_color').bg_color = normalColor3
	elif buttonName != Global.selectedButton and buttonUnlocked:
		self.get('custom_styles/normal/bg_color').bg_color = unlockedNormalColor
	
	if  str(Global.selectedButton) == buttonName:
		if buttonUnlocked:
			self.get('custom_styles/normal/bg_color').bg_color = unlockedPressedColor
		else:
			if cost == 1:
				self.get('custom_styles/normal/bg_color').bg_color = pressedColor
			if cost == 2:
				self.get('custom_styles/normal/bg_color').bg_color = pressedColor
			if cost == 3:
				self.get('custom_styles/normal/bg_color').bg_color = pressedColor
	
	if !buttonUnlocked:
		for skill in Global.unlockedSkills:
			if buttonName == skill:
				changeColor(unlockedNormalColor, unlockedPressedColor, unlockedHoverColor)
				buttonUnlocked = true

func changeColor(normal, pressed, hover):
	self.get('custom_styles/normal/bg_color').bg_color = normal
	self.get('custom_styles/pressed/bg_color').bg_color = pressed
	self.get('custom_styles/hover/bg_color').bg_color = hover
