extends Node

const SAVEFILE = "user://SAVEFILE.save"

var game_data = {}

func _ready_():
	var file = File.new
	if not file.file_exists(SAVEFILE):
		game_data= {
			"fullscreen_on": false,
			"master_vol": -10,
			"music_vol": -10,
			"sfx_vol": -10,
			
		}
		save_data()
	file.opem(SAVEFILE, File.READ)
	game_data = file.get_var()
	file.clost()
	
func save_data():
	var file = File.new()
	file.open(SAVEFILE, File.WRITE)
	file.store_var(game_data)
	file.close()

