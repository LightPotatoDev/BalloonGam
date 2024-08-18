extends Node2D

@export var dir:Vector2
@onready var ray = $RayCast2D
var balloon

func _process(delta):
	if ray.is_colliding():
		balloon = ray.get_collider().get_parent()
		balloon.scalable_dir[dir] = true
	else:
		if balloon != null:
			balloon.scalable_dir[dir] = false
			balloon = null
