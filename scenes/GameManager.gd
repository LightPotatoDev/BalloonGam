extends Node2D

var yes_tiles_left:int = 0
var no_tiles:int = 0
var balloon_scaled:bool = false

@export var lv_data:LevelData

func _input(_event):
	if Global.game_state != Global.STATES.DEFAULT:
		return
	if Input.is_action_just_pressed("undo"):
		EventBus.undo.emit()
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

func _init():
	EventBus.yes_tile_exist.connect(_on_yes_tile_exist)
	EventBus.yes_tile.connect(_on_yes_tile)
	EventBus.no_tile.connect(_on_no_tile)
	EventBus.one_balloon_scaled.connect(_on_one_balloon_scaled)

func _ready():
	add_child(lv_data.lv_scene.instantiate())
	$Control/Lv.text = "Level "+ str(lv_data.lv_number)
	$Control/Title.text = lv_data.lv_title
	
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
		
func _process(_delta):
	if yes_tiles_left == 0 and no_tiles == 0 and Global.game_state == Global.STATES.DEFAULT:
		Global.game_state = Global.STATES.WIN
		print('win')
	if balloon_scaled == true:
		EventBus.move.emit()
		balloon_scaled = false
		
func _on_one_balloon_scaled():
	balloon_scaled = true
