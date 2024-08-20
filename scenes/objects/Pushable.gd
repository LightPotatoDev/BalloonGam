extends TileMap
class_name Pushable

var child_pos:PackedVector2Array = []
var things_to_move = {} #collider:null
@onready var ray:RayCast2D = $RayCast2D
@onready var timer:Timer = $Timer

@export var is_player:bool = false
var tween:Tween

var pos_history:PackedVector2Array = []
	
func _ready():
	child_pos = get_used_cells(0)
	EventBus.undo.connect(_on_undo)
	EventBus.move.connect(_on_move)
		
func get_input():
	if not (Global.game_state == Global.STATES.DEFAULT and is_player and !child_pos.is_empty()):
		return
	const INPUTS = {"ui_left":Vector2.LEFT, 
					"ui_right":Vector2.RIGHT, 
					"ui_up":Vector2.UP, 
					"ui_down":Vector2.DOWN}
	for key in INPUTS.keys():
		var key_just_pressed = Input.is_action_just_pressed(key)
		var key_hold = Input.is_action_pressed(key) and timer.is_stopped()
		if key_just_pressed or key_hold:
			if check_move_collision(INPUTS[key]):
				instant_finish_tween()
				EventBus.move.emit()
				move(INPUTS[key])
				
				if key_just_pressed:
					timer.start(0.2)
				else:
					timer.start(0.1)
			else:
				cant_move(INPUTS[key])
			
	if Input.is_action_just_pressed("ui_copy"):
		print(pos_history)
		
func _physics_process(_delta):
	get_input()
			
func check_move_collision(dir:Vector2, exclude_list = []) -> bool:
	var movable:bool = true
	things_to_move = {}
	for col in get_all_colliders(dir):
		if movable == false:
			break
		var group = col.get_groups()[0]
		exclude_list.append(self)
		if group == "wall":
			movable = false
		if group == "balloon" and col.get_parent() not in exclude_list:
			movable = col.get_parent().check_move_collision(dir, exclude_list)
			if movable:
				things_to_move[col.get_parent()] = null

	return movable

func get_all_colliders(dir:Vector2):
	var cols:Dictionary = {}
	for pos in child_pos:
		var col = check_spot_collision(pos,dir)
		if col != null:
			cols[col] = null
	return cols.keys()
	
func check_spot_collision(pos:Vector2, dir:Vector2):
	ray.position = pos*32 + Vector2.ONE * 16
	ray.target_position = dir * 32
	ray.force_raycast_update()
	return ray.get_collider()
	
func move(dir:Vector2):
	for thing in things_to_move:
		thing.move(dir)
	instant_finish_tween()
	position += dir*32
	
	for child in get_children():
		if child is BalloonTile or child is BalloonFace:
			child.on_pos_move(dir)

func cant_move(dir:Vector2):
	pass
	#TODO - add 'not moving' animation
		
func _on_move():
	pos_history.append(position)
	
func instant_finish_tween():
	if tween != null and tween.is_running():
		tween.pause()
		tween.custom_step(1)
	
func _on_undo():
	if pos_history.size() == 0:
		print('nothing to undo')
		return
		
	position = pos_history[-1]
	pos_history.remove_at(pos_history.size()-1)
		
func destroy():
	for pos in child_pos:
		erase_cell(0,pos)
	child_pos = []
