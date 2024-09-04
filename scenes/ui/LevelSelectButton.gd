extends SceneChangeButton

@export var lv : int
@export var sub_lv : int

func _ready():
	$Label.text = str(sub_lv)
	$Completed.visible = Global.completed[lv-1][sub_lv-1]

func _on_pressed():
	super._on_pressed()
	Global.lv = lv
	Global.sub_lv = sub_lv
