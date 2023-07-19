extends Label

var time = 900 #15 mins

func _process(delta):
	time -= delta

	var secs = fmod(time, 60)
	var mins = fmod(time, 60*60) / 60
	var timePassed = "%02d:%02d" % [mins,secs]
	text = timePassed
