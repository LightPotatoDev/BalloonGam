extends Node2D

var turned_on:bool = false
@onready var ray = $RayCast2D
var balloon = null

func _process(delta):
	if ray.is_colliding():
		if balloon == null:
			balloon = ray.get_collider()
			turned_on = true
			EventBus.no_tile.emit(true)
	else:
		if balloon != null:
			EventBus.no_tile.emit(false)
			turned_on = false
			balloon = null

	$On.visible = turned_on
	$Off.visible = !turned_on
