extends Node

enum STATES {DEFAULT, MOVING, WIN, TRANSITION}
var game_state:int = STATES.DEFAULT

var cur_level:int = 1
