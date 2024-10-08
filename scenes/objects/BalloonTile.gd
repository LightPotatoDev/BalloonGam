extends CharacterBody2D
class_name BalloonTile

@onready var anim = $AnimationPlayer
#var tween:Tween

func scale_anim():
	anim.stop()
	anim.play("scale")
	
func on_pos_move(dir:Vector2):
	$Sprite2D.position -= dir * 32
	var tween = create_tween()
	tween.tween_property($Sprite2D,"position",Vector2.ZERO,0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
