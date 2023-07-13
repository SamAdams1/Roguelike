extends Position2D

onready var label = get_node("Label")
onready var tween = get_node("Tween")
var amount = 0

var velocity = Vector2.ZERO

func _ready():
	var randNum = RandomNumberGenerator.new()
	randNum.randomize()
	label.set_text(str(amount * randNum.randi_range(9, 13)))
	
	var numSideMovement = randNum.randi_range(-40, 40) * 4
	velocity = Vector2(numSideMovement, 20)
	tween.interpolate_property(self, 'scale', scale, Vector2(1, 1), 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(self, 'scale', Vector2(1, 1), Vector2(0.1, 0.1), 1, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.3)
	tween.start()

	
func _process(delta):
	position += velocity * delta


func _on_Tween_tween_completed(_object, _key):
	self.queue_free()
