extends CharacterBody2D
class_name BalloonTile

@onready var anim = $AnimationPlayer
var moved_before:bool = false

func _ready():
	EventBus.move.connect(_on_move)
	EventBus.undo.connect(_on_undo)

func scale_anim():
	anim.stop()
	anim.play("scale")
	
func _on_move():
	moved_before = true

func _on_undo():
	moved_before = false

func _on_area_2d_body_entered(body):
	if body.get_parent() != self.get_parent() and moved_before:
		pass
