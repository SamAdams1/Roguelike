extends Button
onready var buttonName = self.name
onready var unlockedNormalColor = Color(0.976471, 0.768627, 0.215686)
onready var unlockedHoverColor = Color(0.984314, 0.819608, 0.388235)
onready var unlockedPressedColor = Color(0.84375, 0.663665, 0.18457)
onready var normalColor = Color(0.360784, 0.223529, 0.584314)
onready var hoverColor = Color(0.415686, 0.262745, 0.670588)
onready var pressedColor = Color(0.247059, 0.019608, 0.443137)

var unlockedSkills = Global.unlockedSkills
var buttonUnlocked = false 


func _ready():
	if buttonName in Global.unlockedSkills:
		changeColor(unlockedNormalColor, unlockedHoverColor, unlockedPressedColor)
	else:
		changeColor(normalColor, hoverColor, pressedColor)

func _process(_delta):
	if buttonName != Global.selectedButton and !buttonUnlocked:
		self.get('custom_styles/normal/bg_color').bg_color = normalColor
	elif buttonName != Global.selectedButton and buttonUnlocked:
		self.get('custom_styles/normal/bg_color').bg_color = unlockedNormalColor
	
	if  str(Global.selectedButton) == buttonName:
		if buttonUnlocked:
			self.get('custom_styles/normal/bg_color').bg_color = unlockedPressedColor
		else:
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
