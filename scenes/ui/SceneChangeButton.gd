extends TextureButton
class_name SceneChangeButton

@export var scene_to:String = 'Main'

func _on_pressed():
	scale = Vector2.ONE * 1
	if Global.game_state == Global.STATES.DEFAULT:
		Transition.change_scene(scene_to)
		$AudioStreamPlayer.play()

func _on_mouse_entered():
	scale = Vector2.ONE * 1.1

func _on_mouse_exited():
	scale = Vector2.ONE * 1

func _on_button_down():
	scale = Vector2.ONE * 0.9
