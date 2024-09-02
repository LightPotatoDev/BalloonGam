extends SceneChangeButton

@export var lv : int
@export var sub_lv : int

func _on_pressed():
	super._on_pressed()
	Global.lv = lv
	Global.sub_lv = sub_lv
