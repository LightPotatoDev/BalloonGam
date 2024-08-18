extends Node2D

@export var dir:Vector2
@onready var anim = $AnimationPlayer
var colliding:bool = false

func _input(_event):
	if Input.is_action_just_pressed("ui_accept") and colliding:
		anim.stop()
		anim.play("air_add")

func _on_area_2d_body_entered(balloon):
	print('a')
	colliding = true
	balloon.get_parent().scalable_dir[dir] = true

func _on_area_2d_body_exited(balloon):
	colliding = false
	balloon.get_parent().scalable_dir[dir] = false
