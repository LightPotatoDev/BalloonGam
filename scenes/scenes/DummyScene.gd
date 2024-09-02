extends Node2D

func _on_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
