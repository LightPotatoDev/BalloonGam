extends Pushable
class_name Balloon

var scalable_dir = {Vector2.UP:false, Vector2.RIGHT:false, Vector2.DOWN:false, Vector2.LEFT:false}
var child_pos_hist = []

func get_input():
	super.get_input()
	if Global.game_state != Global.STATES.DEFAULT:
		return
	if Input.is_action_just_pressed("ui_accept"):
		#print(scalable_dir)
		var pos_to_add:Dictionary = {} #used as set
		for dir in scalable_dir:
			if scalable_dir[dir] == true:
				for p in determine_scale_pos(dir):
					pos_to_add[p] = null
				
		for pos in pos_to_add.keys():
			scale_balloon(pos)

func determine_scale_pos(dir:Vector2) -> PackedVector2Array:
	var pos_to_add:PackedVector2Array = []
	for pos in child_pos:
		if check_spot_collision(pos,dir) == null: #TODO: prevent dupes
			pos_to_add.append(pos + dir)
			
	return pos_to_add
	
func scale_balloon(pos:Vector2):
	set_cell(0,pos,0,Vector2.ZERO,1)
	child_pos.append(pos)
	await get_tree().process_frame
	for child in get_children():
		if child is BalloonTile:
			child.scale_anim()

func _on_move():
	super._on_move()
	child_pos_hist.append(child_pos.duplicate())

func _on_undo():
	super._on_undo()
	if child_pos_hist.size() == 0:
		return
	
	var prev_child:Dictionary
	for p in child_pos_hist[-1]:
		prev_child[p] = null
	var to_delete = []
	
	for pos in child_pos:
		if pos not in prev_child:
			to_delete.append(pos)
	for pos in to_delete:
		erase_cell(0,pos)
	child_pos = child_pos_hist[-1].duplicate()
	child_pos_hist.remove_at(child_pos_hist.size()-1)
