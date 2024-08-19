extends Node2D

var turned_on:bool = false

func _ready():
	EventBus.no_tile_exist.emit()

func _process(delta):
	$On.visible = turned_on
	$Off.visible = !turned_on
	$Area2D.monitoring = true

func _on_area_2d_body_entered(body):
	await get_tree().process_frame
	turned_on = true
	EventBus.no_tile.emit(true)

func _on_area_2d_body_exited(body):
	await get_tree().process_frame
	turned_on = false
	EventBus.no_tile.emit(false)

