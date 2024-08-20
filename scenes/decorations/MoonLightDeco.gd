extends Sprite2D

var original_scale:Vector2 = Vector2.ZERO
@export var scale_amount:float = 1
@export var move_time:float = 1

func _ready():
	original_scale = scale
	var tween = create_tween().set_loops()
	tween.tween_property(self, "scale", original_scale * scale_amount, move_time).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "scale", original_scale, move_time).set_trans(Tween.TRANS_QUAD)
