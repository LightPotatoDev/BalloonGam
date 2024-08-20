extends Sprite2D

@export var move_y:float = 0
@export var move_time:float = 1

func _ready():
	var tween = create_tween().set_loops()
	tween.tween_property(self, "position", position + Vector2(0,move_y), move_time).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "position", position + Vector2(0,-move_y), move_time).set_trans(Tween.TRANS_QUAD)
