extends Node2D


func _on_area_2d_body_entered(balloon):
	balloon.get_parent().destroy()

