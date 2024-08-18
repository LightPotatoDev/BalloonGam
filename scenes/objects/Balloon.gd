extends Pushable
class_name Balloon

var scalable_dir = {Vector2.UP:false, Vector2.RIGHT:false, Vector2.DOWN:false, Vector2.LEFT:false}
var child_pos_hist = []

func _on_input(key:String):
	super._on_input(key)
	if key == "ui_accept":
		var pos_to_add:Dictionary = {} #used as set
		for dir in scalable_dir:
			if scalable_dir[dir] == true:
				for p in determine_scale_pos(dir):
					pos_to_add[p] = null
					
		if not pos_to_add.is_empty():
			EventBus.balloon_scaled.emit()
				
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
	print(child_pos_hist[-1])
	if child_pos_hist.size() == 0:
		return
	
	var prev_child:Dictionary = {} #set
	var cur_child:Dictionary = {} #set
	for p in child_pos_hist[-1]:
		prev_child[p] = null
	for p in child_pos:
		cur_child[p] = null
		
	for pos in child_pos:
		if pos not in prev_child:
			erase_cell(0,pos)
			
	for pos in child_pos_hist[-1]:
		if pos not in cur_child:
			set_cell(0,pos,0,Vector2.ZERO,1)
	
	child_pos = child_pos_hist[-1].duplicate()
	child_pos_hist.remove_at(child_pos_hist.size()-1)

func destroy():
	super.destroy()
	#TODO - add balloon popping particle
