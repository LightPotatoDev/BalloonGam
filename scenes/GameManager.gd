extends Node2D

var yes_tiles_left:int = 0
var no_tiles:int = 0
var balloon_scaled:bool = false
const ACTIONS = ['ui_right', 'ui_down', 'ui_left', 'ui_up', 'undo', 'ui_accept']

func _input(_event):
	if Global.game_state != Global.STATES.DEFAULT:
		return
	for action in ACTIONS:
		if Input.is_action_just_pressed(action):
			EventBus.key_press.emit(action)
			if action == 'undo':
				EventBus.undo.emit()
			if action == 'ui_accept':
				EventBus.move.emit()
				undo_when_nothing_scales()
			wait_a_bit()

func _init():
	EventBus.yes_tile_exist.connect(_on_yes_tile_exist)
	EventBus.yes_tile.connect(_on_yes_tile)
	EventBus.no_tile.connect(_on_no_tile)
	EventBus.balloon_scaled.connect(_on_balloon_scaled)
	
func _on_yes_tile_exist():
	yes_tiles_left += 1

func _on_yes_tile(power):
	if power == true:
		yes_tiles_left -= 1
	else:
		yes_tiles_left += 1
		
func _on_no_tile(power):
	if power == true:
		no_tiles += 1
	else:
		no_tiles -= 1
		
func _on_balloon_scaled():
	balloon_scaled = true
	print('scale')
		
func _process(_delta):
	if yes_tiles_left == 0 and no_tiles == 0 and Global.game_state == Global.STATES.DEFAULT:
		Global.game_state = Global.STATES.WIN
		print('win')
		
func wait_a_bit():
	Global.game_state = Global.STATES.MOVING
	await get_tree().create_timer(0.05).timeout
	Global.game_state = Global.STATES.DEFAULT
		
func undo_when_nothing_scales():
	await get_tree().create_timer(0.03).timeout
	if balloon_scaled == false:
		EventBus.undo.emit()
	else:
		balloon_scaled = false
