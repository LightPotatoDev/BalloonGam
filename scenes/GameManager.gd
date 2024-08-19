extends Node2D

var yes_tiles_left:int = 0
var no_tiles:int = 0
var balloon_scaled:bool = false

@export var lv_data:LevelData
@export var manual_level_insert:bool = false

func _input(_event):
	if Global.game_state != Global.STATES.DEFAULT:
		return
	if Input.is_action_just_pressed("undo"):
		EventBus.undo.emit()
		$UndoSound.play()
	if Input.is_action_just_pressed("restart"):
		Transition.change_scene("DummyScene")

func _init():
	EventBus.yes_tile_exist.connect(_on_yes_tile_exist)
	EventBus.yes_tile.connect(_on_yes_tile)
	EventBus.no_tile_exist.connect(_on_no_tile_exist)
	EventBus.no_tile.connect(_on_no_tile)
	EventBus.one_balloon_scaled.connect(_on_one_balloon_scaled)

func _ready():
	if not manual_level_insert:
		lv_data = load("res://resources/leveldatas/lv"+ str(Global.cur_level) + ".tres")
	add_child(lv_data.lv_scene.instantiate())
	$Control/Lv.text = "Level "+ str(lv_data.lv_number)
	$Control/Title.text = lv_data.lv_title
	Global.game_state = Global.STATES.DEFAULT
	
func _on_yes_tile_exist():
	yes_tiles_left += 1

func _on_yes_tile(power):
	if power == true:
		yes_tiles_left -= 1
	else:
		yes_tiles_left += 1
		
func _on_no_tile_exist():
	$Control/NoTile.visible = true
		
func _on_no_tile(power):
	if power == true:
		no_tiles += 1
	else:
		no_tiles -= 1
		
func _process(_delta):
	if yes_tiles_left == 0 and no_tiles == 0 and Global.game_state == Global.STATES.DEFAULT:
		Global.game_state = Global.STATES.WIN
		Global.cur_level += 1
		print('win')
		Transition.change_scene("Main")
		$LevelClearSound.play()
	if balloon_scaled == true:
		EventBus.move.emit()
		balloon_scaled = false
		
	$Control/YesTile/YesTilesLeft.text = str(yes_tiles_left)
	$Control/NoTile/NoTiles.text = str(no_tiles)
		
func _on_one_balloon_scaled():
	balloon_scaled = true
