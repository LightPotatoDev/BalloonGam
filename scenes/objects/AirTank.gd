extends Node2D

@export var dir:Vector2
@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D
var colliding:bool = false

func _input(_event):
	if Input.is_action_just_pressed("ui_accept") and colliding:
		anim.stop()
		anim.play("air_add")

func _on_area_2d_body_entered(balloon):
	colliding = true
	sprite.material.set_shader_parameter("width", 2)
	balloon.get_parent().scalable_dir[dir] += 1

func _on_area_2d_body_exited(balloon):
	colliding = false
	sprite.material.set_shader_parameter("width", 0)
	balloon.get_parent().scalable_dir[dir] -= 1
