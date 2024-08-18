extends Node2D

var turned_on:bool = false

func _ready():
	EventBus.yes_tile_exist.emit()

func _process(delta):
	$On.visible = turned_on
	$Off.visible = !turned_on

func _on_area_2d_body_entered(_body):
	turned_on = true
	EventBus.yes_tile.emit(true)

func _on_area_2d_body_exited(_body):
	turned_on = false
	EventBus.yes_tile.emit(false)
