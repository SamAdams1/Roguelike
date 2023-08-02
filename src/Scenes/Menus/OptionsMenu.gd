extends Popup

#settings
onready var fullscreen_val = $Options/OptionsGrid/FCButton
onready var master_val = $Options/OptionsGrid/MasterSlider
onready var sfx_val = $Options/OptionsGrid/SfxSlider
onready var music_val = $Options/OptionsGrid/MusicSlider 


func _ready():
	pass


func _on_FCButton_toggled(button_pressed):
	GlobalSettings.toggle_fullscreen(button_pressed)
	

func _on_MasterSlider_value_changed(value):
	GlobalSettings.update_master_vol(value)
	

func _on_SfxSlider_value_changed(value):
	GlobalSettings.update_sfx_vol(value)
	

func _on_MusicSlider_value_changed(value):
	GlobalSettings.update_music_vol(value)
	
