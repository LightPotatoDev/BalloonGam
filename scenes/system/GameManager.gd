extends Node2D

var yes_tiles_left:int = 0
var no_tiles:int = 0
var balloon_scaled:bool = false

@onready var timer:Timer = $Timer

@export var lv_data:LevelData
@export var manual_level_insert:bool = false

func _physics_process(_delta):
	if Global.game_state != Global.STATES.DEFAULT:
		return
	var key_just_pressed = Input.is_action_just_pressed('undo')
	var key_hold = Input.is_action_pressed('undo') and timer.is_stopped()
	if key_just_pressed or key_hold:
		EventBus.undo.emit()
		$UndoSound.play()
		if key_just_pressed:
			timer.start(0.15)
		else:
			timer.start(0.09)
	if Input.is_action_just_pressed("restart"):
		EventBus.restart.emit()
		Transition.change_scene("DummyScene")

func _init():
	EventBus.yes_tile_exist.connect(_on_yes_tile_exist)
	EventBus.yes_tile.connect(_on_yes_tile)
	EventBus.no_tile_exist.connect(_on_no_tile_exist)
	EventBus.no_tile.connect(_on_no_tile)
	EventBus.one_balloon_scaled.connect(_on_one_balloon_scaled)
	
func get_lv_path(lv:int, sub_lv:int):
	const prefix = "res://resources/leveldatas"
	var part = "/pt" + str(lv)
	var lv_file = "/lv" + str(lv) + "-" + str(sub_lv)
	const postfix = ".tres"
	return prefix + part + lv_file + postfix

func _ready():
	if not manual_level_insert:
		lv_data = load(get_lv_path(Global.lv, Global.sub_lv))
	add_child(lv_data.lv_scene.instantiate())
	$Control/Lv.text = "Level "+ str(Global.lv) + "-" + str(Global.sub_lv)
	$Control/Title.text = lv_data.lv_title
	
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
		$LevelClearSound.play()
		handle_level_change()
	if balloon_scaled == true:
		EventBus.move.emit()
		balloon_scaled = false
		
	$Control/YesTile/YesTilesLeft.text = str(yes_tiles_left)
	$Control/NoTile/NoTiles.text = str(no_tiles)
		
func handle_level_change():
	Global.complete_level(Global.lv, Global.sub_lv)
	if ResourceLoader.exists(get_lv_path(Global.lv, Global.sub_lv+1)):
		Global.sub_lv += 1
		Transition.change_scene("Main")
	elif ResourceLoader.exists(get_lv_path(Global.lv+1, 1)):
		Global.lv += 1
		Global.sub_lv = 1
		Transition.change_scene("Main")
	else:
		Transition.change_scene("LevelSelect")
	
func _on_one_balloon_scaled():
	balloon_scaled = true
