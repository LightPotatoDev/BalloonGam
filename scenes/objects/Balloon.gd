extends Pushable
class_name Balloon

@onready var balloon_pop_particle = preload("res://scenes/effects/BalloonPopParticle.tscn")
@onready var balloon_face = preload("res://scenes/objects/BalloonFace.tscn")
@export_range(1,2) var balloon_color:int = 1
var face_inst

var scalable_dir = {Vector2.UP:0, Vector2.RIGHT:0, Vector2.DOWN:0, Vector2.LEFT:0}
var child_pos_hist = []
var child_snapshot = []

func _ready():
	super._ready()
	EventBus.restart.connect(_on_restart)
	child_snapshot = child_pos.duplicate()
	
	var face_pos = child_pos[randi() % child_pos.size()]
	face_inst = balloon_face.instantiate()
	face_inst.position = face_pos * 32 + Vector2.ONE * 16
	add_child(face_inst)

func get_input():
	super.get_input()
	if Global.game_state != Global.STATES.DEFAULT:
		return
	#every frame wtf, feels like shit
	child_snapshot = child_pos.duplicate()
	if Input.is_action_just_pressed("ui_accept"):
		var pos_to_add:Dictionary = {} #used as set
		for dir in scalable_dir:
			for i in range(1,scalable_dir[dir]+1):
				for p in determine_scale_pos(dir*i):
					pos_to_add[p] = null
			
		if !pos_to_add.is_empty():
			scale_balloon(pos_to_add.keys())
			EventBus.one_balloon_scaled.emit()
			
func _process(_delta):
	face_inst.visible = !child_pos.is_empty()

func determine_scale_pos(dir:Vector2) -> PackedVector2Array:
	var pos_to_add:PackedVector2Array = []
	for pos in child_pos:
		if check_spot_collision(pos,dir) == null:
			pos_to_add.append(pos + dir)
			
	return pos_to_add
	
func scale_balloon(pos:PackedVector2Array):
	for p in pos:
		set_cell(0,p,0,Vector2.ZERO,balloon_color)
		child_pos.append(p)
	$BalloonScaleSound.play()
	face_inst.on_scale()
	await get_tree().process_frame
	for child in get_children():
		if child is BalloonTile:
			child.scale_anim()
	#TODO: add face anim

func move(dir:Vector2):
	super.move(dir)
	$BalloonMoveSound.play()
	
func _on_move():
	super._on_move()
	child_pos_hist.append(child_snapshot)

func _on_undo():
	super._on_undo()
	if child_pos_hist.size() == 0:
		return
	
	var prev_child:Dictionary = {}
	var cur_child:Dictionary = {}
	for p in child_pos_hist[-1]:
		prev_child[p] = null
	for p in child_pos:
		cur_child[p] = null
	
	for pos in child_pos:
		if pos not in prev_child:
			erase_cell(0,pos)

	for pos in child_pos_hist[-1]:
		if pos not in cur_child:
			set_cell(0,pos,0,Vector2.ZERO,balloon_color)

	child_pos = child_pos_hist[-1].duplicate()
	child_pos_hist.remove_at(child_pos_hist.size()-1)

func _on_restart():
	destroy()
	
func destroy():
	var pp = child_pos.duplicate()
	super.destroy()
	$BalloonBurstSound.play()
	for p in pp:
		var particle = balloon_pop_particle.instantiate()
		#hardcode moment :(
		if self.get_name() == "Balloon":
			particle.process_material.color = Color.html("#ff1650")
		else:
			particle.process_material.color = Color.html("#1751ff")
		particle.position = p * 32 + Vector2.ONE * 16
		add_child(particle)
