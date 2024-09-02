extends CanvasLayer

func begin():
	$AnimationPlayer.play("transitionOut")
	
func change_scene(sceneName):
	Global.game_state = Global.STATES.TRANSITION
	var scene = "res://scenes/scenes/" + sceneName + ".tscn"
	$AnimationPlayer.play('RESET')
	$AnimationPlayer.play('trans_in')
	await $AnimationPlayer.animation_finished
# warning-ignore:return_value_discarded
	get_tree().change_scene_to_file(scene)
	$AnimationPlayer.play("trans_out")
	await $AnimationPlayer.animation_finished
	Global.game_state = Global.STATES.DEFAULT
