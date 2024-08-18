extends CharacterBody2D
class_name BalloonTile

@onready var anim = $AnimationPlayer

func scale_anim():
	anim.stop()
	anim.play("scale")
