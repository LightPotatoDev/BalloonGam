extends TextureButton
@export var scene_to:String = 'Main'

func _on_pressed():
	if Global.game_state == Global.STATES.DEFAULT:
		Transition.change_scene(scene_to)
		$AudioStreamPlayer.play()

func _on_mouse_entered():
	pass
