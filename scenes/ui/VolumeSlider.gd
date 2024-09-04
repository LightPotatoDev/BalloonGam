extends HSlider

var music_bus = AudioServer.get_bus_index("Music")
var sfx_bus = AudioServer.get_bus_index("Sfx")
enum BUS {MUSIC, SFX}
@export var my_bus:BUS
var real_bus

func _ready():
	if my_bus == BUS.MUSIC:
		real_bus = music_bus
		value = Global.music_volume
	else:
		real_bus = sfx_bus
		value = Global.sfx_volume

func _on_value_changed(val):
	AudioServer.set_bus_volume_db(real_bus,val)
	
	if val == min_value:
		AudioServer.set_bus_mute(real_bus, true)
	else:
		AudioServer.set_bus_mute(real_bus, false)
		
	if my_bus == BUS.MUSIC:
		Global.music_volume = value
	else:
		Global.sfx_volume = value
