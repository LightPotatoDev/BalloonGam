extends Node2D

var turned_on:bool = false

func _process(delta):
	$On.visible = turned_on
	$Off.visible = !turned_on


func _on_area_2d_body_entered(body):
	turned_on = true
	EventBus.no_tile.emit(true)

func _on_area_2d_body_exited(body):
	turned_on = false
	EventBus.no_tile.emit(false)

