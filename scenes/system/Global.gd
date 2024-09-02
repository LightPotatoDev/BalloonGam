extends Node

enum STATES {DEFAULT, MOVING, WIN, TRANSITION}
var game_state:int = STATES.DEFAULT

var lv:int = 1
var sub_lv:int = 1

func _process(delta):
	print(game_state)
