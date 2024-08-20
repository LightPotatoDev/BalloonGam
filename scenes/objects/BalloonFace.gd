extends Node2D
class_name BalloonFace

@onready var anim = $AnimationPlayer

func on_pos_move(dir:Vector2):
	anim.stop(false)
	anim.play('move')
	$Sprite2D.position -= dir * 32
	
	var scale_amount = Vector2(1.2,0.8)
	if dir.x == 0:
		scale_amount = Vector2(0.8,1.2)
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property($Sprite2D,"position",Vector2.ZERO,0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property($Sprite2D,"offset",dir*3,0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property($Sprite2D,"scale",scale_amount,0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.chain().tween_property($Sprite2D,"scale",Vector2.ONE,0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.chain().tween_property($Sprite2D,"offset",Vector2.ZERO,0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	await anim.animation_finished
	anim.play('idle')
	
func on_scale():
	anim.stop(false)
	anim.play('scale')
	
	await anim.animation_finished
	anim.play('idle')
